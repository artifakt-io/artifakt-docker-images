#!/bin/bash
set -e

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
	set -- ruby "$@"
fi

exec "$@"