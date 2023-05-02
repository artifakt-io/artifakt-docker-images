#!/bin/bash
set -e

PERSISTENT_FOLDER_LIST=('wp-content/cache' 'wp-content/uploads' 'wp-content/backups' 'wp-content/backup-db' 'wp-content/upgrade')

for persistent_folder in ${PERSISTENT_FOLDER_LIST[@]}; do
  echo Mount $persistent_folder directory
  rm -rf /var/www/html/$persistent_folder && \
    mkdir -p /data/$persistent_folder && \
    ln -sfn /data/$persistent_folder /var/www/html/$persistent_folder && \
    chown -h www-data:www-data /var/www/html/$persistent_folder /data/$persistent_folder
done

if [ -f "/.artifakt/entrypoint.sh" ]; then
	chmod u+x /.artifakt/entrypoint.sh
  	echo "Entrypoint.sh script detected and executable - Starting..."
  	source /.artifakt/entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
