#!/bin/bash
set -e

PERSISTENT_FOLDER_LIST=("public/uploads" "var/log")

for persistent_folder in ${PERSISTENT_FOLDER_LIST[@]}; do
  echo Mount $persistent_folder directory
  rm -rf /var/www/html/$persistent_folder && \
    mkdir -p /data/$persistent_folder && \
    ln -sfn /data/$persistent_folder /var/www/html/$persistent_folder && \
    chown -h www-data:www-data /var/www/html/$persistent_folder /data/$persistent_folder
done

# Generate file holding custom keys 
if [[ ! -f /data/secret-key ]]; then
  key=$(openssl rand -base64 24)
  echo export WORDPRESS_SECRET=$key >> /data/secret-key
fi

source /data/secret-key

if [[ -x "/.artifakt/entrypoint.sh" ]]; then
    source /.artifakt/entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
