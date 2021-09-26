#!/bin/bash
set -e

echo "Creating all symbolic links"

# creating main folders ain folders
mkdir -p /var/www/html/public /var/www/html/custom /var/www/html/var

PERSISTENT_FOLDER_LIST=("custom/plugins" "files" "config/jwt" "public/theme" "public/media" "public/thumbnail" "public/bundles" "public/sitemap")
for persistent_folder in ${PERSISTENT_FOLDER_LIST[@]}; do
  echo Mount $persistent_folder directory
  rm -rf /var/www/html/$persistent_folder && \
    mkdir -p /data/$persistent_folder && \
    mkdir -p /var/www/html/$persistent_folder && \
    ln -sfn /data/$persistent_folder /var/www/html/$persistent_folder && \
    chown -h -R www-data:www-data /var/www/html/$persistent_folder /data/$persistent_folder && \
    ls -la /var/www/html/$persistent_folder
done

echo Mount "var/logs" directory
rm -rf /var/www/html/var/logs && \
  mkdir -p /var/log/artifakt && \
  ln -sfn /var/log/artifakt /var/www/html/var/logs && \
  chown -h www-data:www-data /var/www/html/var/logs /var/log/artifakt && \
  ls -la /var/log/artifakt

ln -snf /data/.uniqueid.txt /var/www/html/

if [[ -x "/.artifakt/entrypoint.sh" ]]; then
    source /.artifakt/entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
