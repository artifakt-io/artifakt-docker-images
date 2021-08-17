#!/bin/bash
set -e

PERSISTENT_FOLDER_LIST=("public/uploads")

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

if [ -x "/.artifakt/entrypoint.sh" ]; then
    source /.artifakt/entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"