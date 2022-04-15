#!/bin/bash
set -e

PERSISTENT_FOLDER_LIST=('web/sites/default/files' 'web/sites/default/private')

for persistent_folder in ${PERSISTENT_FOLDER_LIST[@]}; do
  echo Mount $persistent_folder directory
  rm -rf /opt/drupal/$persistent_folder && \
    mkdir -p /data/$persistent_folder && \
    ln -sfn /data/$persistent_folder /opt/drupal/$persistent_folder && \
    chown -h www-data:www-data /opt/drupal/$persistent_folder /data/$persistent_folder
done

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

# inject dotenv conf file
[[ ! -f /data/sites/default/settings.php && -f /opt/settings.php ]] && \
  echo "first install, found a mounted conf file, copying it to default path" && \
  mkdir -p /data/sites/default && \
  php -r 'include "/opt/drupal/vendor/autoload.php"; echo \Drupal\Component\Utility\Crypt::randomBytesBase64(55);' > /data/salt.txt && \
  cp /opt/settings.php /data/sites/default/settings.php && \
  chown www-data:www-data /data/sites/default/settings.php /data/salt.txt

# move config to persistent data folder
[[ ! -d /data/config/sync ]] && \
  mkdir -p /data/config/sync && \
  ls -la /data/config

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
