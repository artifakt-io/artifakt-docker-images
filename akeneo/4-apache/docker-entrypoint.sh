#!/bin/bash
set -e

PERSISTENT_FOLDER_LIST=("public/uploads")

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

if [ -x "/.artifakt/entrypoint.sh" ]; then
    source /.artifakt/entrypoint.sh
fi

su www-data -s /bin/sh -c './bin/console pim:installer:check-requirements'

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"