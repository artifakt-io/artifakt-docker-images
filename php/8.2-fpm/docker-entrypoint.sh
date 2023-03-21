#!/bin/bash

set -e

echo Copy modified/new files from container /var/www/html to volume /data
cp -ur /var/www/html/* /data || true

echo Link /data directory to /var/www/html
rm -rf /var/www/html && \
  mkdir -p /data && \
  mkdir -p /var/www && \
  ln -sfn /data /var/www/html && \
  chown -h -R -L www-data:www-data /var/www/html /data

if [[ -x "/.artifakt/entrypoint.sh" ]]; then
    source /.artifakt/entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

exec "$@"
