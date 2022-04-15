#!/bin/bash
set -e

PERSISTENT_FOLDER_LIST=("var/cache" "var/sessions" "public/media" "public/uploads" "config/jwt")

for persistent_folder in ${PERSISTENT_FOLDER_LIST[@]}; do
  echo Mount $persistent_folder directory
  rm -rf /var/www/html/$persistent_folder && \
    mkdir -p /data/$persistent_folder && \
    ln -sfn /data/$persistent_folder /var/www/html/$persistent_folder && \
    chown -h www-data:www-data /var/www/html/$persistent_folder /data/$persistent_folder && \
    ls -la /var/www/html/$persistent_folder 
done

echo Mount "var/log" directory
rm -rf /var/www/html/var/log && \
  mkdir -p /var/log/artifakt && \
  ln -sfn /var/log/artifakt /var/www/html/var/log && \
  chown -h www-data:www-data /var/www/html/var/log /var/log/artifakt && \
  ls -la /var/www/html/var/log

# Generate default passphrase
if [[ ! -f /data/passphrase ]]; then
  key=$(openssl rand -base64 24)
  echo export JWT_PASSPHRASE=$key >> /data/passphrase
  chown www-data:www-data /data/passphrase
fi
source /data/passphrase

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

su www-data -s /bin/sh -c 'php bin/console sylius:install:check-requirements'

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"