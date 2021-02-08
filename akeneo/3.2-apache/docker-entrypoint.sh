#!/bin/sh
set -e

wait-for-it.sh mysql:3306 --timeout=30 -- su www-data -s /bin/sh -c 'cd /var/www/html/pim-community-standard && php bin/console pim:install --symlink --env=prod --quiet || :'

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
