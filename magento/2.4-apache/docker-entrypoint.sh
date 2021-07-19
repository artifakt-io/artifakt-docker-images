#!/bin/bash

[ "$DEBUG" = "true" ] && set -x

PERSISTENT_FOLDER_LIST=('pub/media' 'pub/static/_cache', 'var')

for persistent_folder in ${PERSISTENT_FOLDER_LIST[@]}; do
    echo Mount $persistent_folder directory
    mkdir -p /data/$persistent_folder
    # Preserve and copy original directory content to the persistent directory (keep .htaccess files for example)
    if [ -d "/var/www/html/$persistent_folder/" ]; then
      cp -rf /var/www/html/$persistent_folder/. /data/$persistent_folder && \
      rm -rf /var/www/html/$persistent_folder
    fi
    ln -sfn /data/$persistent_folder /var/www/html/$persistent_folder && \
    chown -Rh www-data:www-data /var/www/html/$persistent_folder /data/$persistent_folder
done

if [[ -x "/.artifakt/entrypoint.sh" ]]; then
    source /.artifakt/entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
