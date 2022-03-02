#!/bin/bash
set -e

PERSISTENT_FOLDER_LIST=("/")

for persistent_folder in ${PERSISTENT_FOLDER_LIST[@]}; do
  echo Copy modified/new files from container (/var/www/html/$persistent_folder ) to volume (/data/$persistent_folder)
  cp -ur /var/www/html/$persistent_folder /data/$persistent_folder

  echo Link /data/$persistent_folder directory to /var/www/html/$persistent_folder
  rm -rf /var/www/html/$persistent_folder && \
    mkdir -p /data/$persistent_folder && \
    ln -sfn /data/$persistent_folder /var/www/html/$persistent_folder && \
    chown -h www-data:www-data /var/www/html/$persistent_folder /data/$persistent_folder
done

if [[ -x "/.artifakt/entrypoint.sh" ]]; then
    source /.artifakt/entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"
