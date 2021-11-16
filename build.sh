#!/usr/bin/env bash
set -e

Options=$@
Optnum=$#

EXITCODE=0

CONFIG="$1"

REGISTRY_TARGET=${REGISTRY_TARGET:-"registry.artifakt.io"}

IMAGE_TARGET="ALL"

TAG_TARGET="ALL"

VERBOSE_MODE=true

LINT_MODE=false

TEST_MODE=false

SKIP_BUILD=false

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

_usage() {

cat <<EOF
NAME:
    ./build.sh - Builds official Docker images of Artifakt

USAGE:
    [options and commands] [-- [extra args]]

OPTIONS:
    -h,--help         display this help
    -i|--image        target name for a specific service (type:string, default:"all")
    -t|--tag          target name for a specific tag (type:string, default:"all")
    -l|--lint         run syntaxic checks on Dockerfiles (type:string, default:"false")
    -s|--skip-build   do not build anything (type:string, default:"false")

EOF
exit

}

while getopts ':h-itvlp' OPTION ; do
  case "$OPTION" in
    i  ) IMAGE_TARGET="$OPTARG"                       	;;
    t  ) TAG_TARGET="$OPTARG"                           ;;
    v  ) VERBOSE_MODE=true                         	    ;;
    l  ) LINT_MODE=false                         	    ;;
    t  ) TEST_MODE=false                         	    ;;
    s  ) SKIP_BUILD=false                         	    ;;
    h  ) _usage                         				;;
    -  ) [ $OPTIND -ge 1 ] && optind=$(expr $OPTIND - 1 ) || optind=$OPTIND
         eval OPTION="\$$optind"
         OPTARG=$(echo $OPTION | cut -d'=' -f2)
         OPTION=$(echo $OPTION | cut -d'=' -f1)
         case $OPTION in
		     --image      ) IMAGE_TARGET="$OPTARG"                  ;;
             --tag        ) TAG_TARGET="$OPTARG"                    ;;
             --lint       ) LINT_MODE="$OPTARG"                     ;;
             --test       ) TEST_MODE="$OPTARG"                     ;;
             --skip-build ) SKIP_BUILD=true                         ;;
             --verbose    ) VERBOSE_MODE=true                       ;;
             --help       ) _usage                         		    ;;
             * )  _usage " Long: >>>>>>>> invalid options (long) "  ;;
         esac
       OPTIND=1
       shift
      ;;
    ? )  _usage "Short: >>>>>>>> invalid options (short) "  ;;
  esac
done

case "$IMAGE_TARGET" in
	ALL | all )
		# all images values
		if [ $TAG_TARGET != "ALL" ]; then
			echo "cannot add tag folder without image, remove tag option or specify existing folder as --image=<folder>"
			exit 1
		fi
		dockerfiles=($( find . -type f -name "Dockerfile" ))
		;;
	*)  if [ ! -d "./${IMAGE_TARGET}" ]; then
			echo "cannot find image '${IMAGE_TARGET}', specify existing folder as --image=<folder>"
			exit 1
		fi

		case "$TAG_TARGET" in
			ALL | all )
				# all tag values
				dockerfiles=($( find ./$IMAGE_TARGET -type f -name "Dockerfile" ))

				;;
			*)  if [ ! -f ./${IMAGE_TARGET}/${TAG_TARGET}/Dockerfile ]; then
					echo "cannot find tag folder '${TAG_TARGET}', specify existing folder as --tag=<folder>"
					exit 1
				fi
				dockerfiles=($( find ./$IMAGE_TARGET/$TAG_TARGET -type f -name "Dockerfile" ))
				;;
		esac
	   ;;
esac

color() {
	local codes=()
	if [ "$1" = 'bold' ]; then
		codes=( "${codes[@]}" '1' )
		shift
	fi
	if [ "$#" -gt 0 ]; then
		local code=
		case "$1" in
			# see https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
			black) code=30 ;;
			red) code=31 ;;
			green) code=32 ;;
			yellow) code=33 ;;
			blue) code=34 ;;
			magenta) code=35 ;;
			cyan) code=36 ;;
			white) code=37 ;;
		esac
		if [ "$code" ]; then
			codes=( "${codes[@]}" "$code" )
		fi
	fi
	local IFS=';'
	echo -en '\033['"${codes[*]}"'m'
}

wrap_color() {
	text="$1"
	shift
	color "$@"
	echo -n "$text"
	color reset
	echo
}

wrap_good() {
	echo "$(wrap_color "$1" white): $(wrap_color "$2" green)"
}
wrap_bad() {
	echo "$(wrap_color "$1" bold): $(wrap_color "$2" bold red)"
}
wrap_warning() {
	wrap_color >&2 "$*" red
}

wrap_docker() {
	$DOCKER_BIN -H=$DOCKER_HOST $1
}

check_command() {
	if command -v "$1" >/dev/null 2>&1; then
		wrap_good "$1 command" 'available'
	else
		wrap_bad "$1 command" 'missing'
		EXITCODE=1
	fi
}

check_file() {
	if [ -f "$1"  ]; then
		if [ "$LINT_MODE" = true ]; then
			if $HADOLINT_BIN < $1 >/dev/null; then
				wrap_good "$1" 'valid'
			else
				wrap_bad "$1" 'invalid, removed'
				dockerfiles=( ${dockerfiles[@]/$1} )
				EXITCODE=1
			fi
		else
			wrap_good "$1" 'found'
		fi
	else
		wrap_bad "$1" 'unreadable'
		EXITCODE=1
	fi

}

check_files() {
	for file in "$@"; do
		echo -n "  - "; check_file "$file"
	done
}

########################################################## MAIN ###

echo ' - "'$(wrap_color 'binary requirements' yellow)'":'

echo -n "  - "; check_command docker
DOCKER_BIN=`command -v docker`

if [[ $TEST_MODE = true ]]; then
	echo -n "  - "; check_command container-structure-test
	CONTAINER_TEST_BIN=`command -v container-structure-test`
fi

if [[ $LINT_MODE = true ]]; then
	echo -n "  - ";
	wrap_good "hadolint docker image" 'available'
	HADOLINT_BIN="docker run --rm -i ghcr.io/hadolint/hadolint:v2.6.0 hadolint --require-label author:text --failure-threshold=error -"
fi

wrap_color "info: reading dockerfile list from current repo ..." white
echo ' - "'$(wrap_color 'dockerfiles' yellow)'":'
check_files "${dockerfiles[@]}"

wrap_color "info: building images..." white
for dockerfile in "${dockerfiles[@]}"
do

	# break path into components
	oIFS="$IFS"
	IFS="/"
	_fields=($dockerfile)
	IFS="$oIFS"
	unset oIFS

	# parse into full image tag
	_image=${_fields[1]}
	if [ "Dockerfile" = "${_fields[2]}" ]; then
		_tag="latest"
		_build_dir=$_image
	else
		_tag="${_fields[2]}"
		_build_dir=$_image/$_tag
	fi

	# run the actual build
	(
		set -Ee
		function _catch {
			wrap_bad "" 'failed!'
			exit 1  # optional; use if you don't want to propagate (rethrow) error to outer shell
		}
		function _finally {
			cd $OLDPWD
		}
		trap _catch ERR
		trap _finally EXIT

		#try
		if [[ $SKIP_BUILD = false  ]]; then
			OLDPWD=$PWD
			echo -n "  - building $_image:$_tag... "
			cd $_build_dir
			DOCKER_BUILDKIT=0 $DOCKER_BIN image build --cache-from $REGISTRY_TARGET/$_image:$_tag --progress=plain -t $REGISTRY_TARGET/$_image:$_tag .
		fi
		if [[ $TEST_MODE = true ]]; then
			LOCAL_TEST_FILE=""
			if [ -f "$SCRIPT_DIR/$_build_dir/test.yaml" ]; then
				LOCAL_TEST_FILE="--config $SCRIPT_DIR/$_build_dir/test.yaml"
			else
				echo -n "  - no test.yaml in $SCRIPT_DIR/$_build_dir, skipping... "
			fi
			echo -n "  - testing image $_image:$_tag... "
			$CONTAINER_TEST_BIN test --image $REGISTRY_TARGET/$_image:$_tag $LOCAL_TEST_FILE --config $SCRIPT_DIR/global.yaml
		fi
		wrap_good "" 'done!'

	)
	# end try catch block

done

exit $EXITCODE

