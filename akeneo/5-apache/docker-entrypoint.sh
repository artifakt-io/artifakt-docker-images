#!/bin/bash
set -e

PERSISTENT_FOLDER_LIST=("public/media" "public/uploads" "var")

for persistent_folder in ${PERSISTENT_FOLDER_LIST[@]}; do
  echo Mount $persistent_folder directory
  rm -rf /var/www/html/pim-community-standard/$persistent_folder && \
    mkdir -p /data/$persistent_folder && \
    ln -sfn /data/$persistent_folder /var/www/html/pim-community-standard/$persistent_folder && \
    chown -h www-data:www-data /var/www/html/pim-community-standard/$persistent_folder /data/$persistent_folder
done

echo Mount "var/logs" directory
rm -rf /var/www/html/pim-community-standard/var/logs && \
  mkdir -p /var/log/artifakt && \
  ln -sfn /var/log/artifakt /var/www/html/pim-community-standard/var/logs && \
  chown -h www-data:www-data /var/www/html/pim-community-standard/var/logs /var/log/artifakt

if [[ -f "/.artifakt/entrypoint.sh" ]]; then

  # source: https://gist.github.com/karlrwjohnson/1921b05c290edb665c238676ef847f3c
  function lock_cmd {
      LOCK_FILE="$1"; shift
      LOCK_TIMEOUT="$1"; shift;

      (
          trap "rm -f $LOCK_FILE" 0
          flock -x -w $LOCK_TIMEOUT 200
          RETVAL=$?
          if [ $RETVAL -ne 0 ]; then
              echo -e "Failed to aquire lock on $LOCK_FILE within $LOCK_TIMEOUT seconds. Is a similar script hung?"
              exit $RETVAL
          fi
          echo -e "Running command: $@"
          source $@
      ) 200>"$LOCK_FILE"
  }

  lock_file=${ARTIFAKT_ENTRYPOINT_LOCK:-/data/artifakt-entrypoint-lock}
  lock_timeout=${ARTIFAKT_TIMEOUT_LOCK:-600}
  lock_cmd $lock_file $lock_timeout /.artifakt/entrypoint.sh
fi

su www-data -s /bin/sh -c './bin/console pim:installer:check-requirements'

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
