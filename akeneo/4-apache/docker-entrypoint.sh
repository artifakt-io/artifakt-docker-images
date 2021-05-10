#!/bin/sh
set -e

wait-for-it.sh mysql:3306 --timeout=90 -- su www-data -s /bin/sh -c 'sleep 10 && cd /var/www/html/pim-community-standard && APP_ENV=dev php bin/console pim:installer:db --catalog src/Akeneo/Platform/Bundle/InstallerBundle/Resources/fixtures/minimal || :'

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
