#!/bin/bash
set -e

echo "Creating all symbolic links"
PERSISTENT_FOLDER_LIST=("custom/plugins" "files" "config/jwt" "public/theme" "public/media" "public/thumbnail" "public/bundles" "public/sitemap") 
for persistent_folder in ${PERSISTENT_FOLDER_LIST[@]}; do
  echo Mount $persistent_folder directory
  rm -rf /var/www/html/$persistent_folder && \
    mkdir -p /data/$persistent_folder && \
    ln -sfn /data/$persistent_folder /var/www/html/$persistent_folder && \
    chown -h www-data:www-data /var/www/html/$persistent_folder /data/$persistent_folder
done

ln -snf /data/.uniqueid.txt /var/www/html/

until nc -z -v -w30 $DATABASE_HOST 3306
do
  echo "Waiting for database connection..."
  # wait for 5 seconds before check again
  sleep 5
done

if [[ -x "/.artifakt/entrypoint.sh" ]]; then
    source /.artifakt/entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
