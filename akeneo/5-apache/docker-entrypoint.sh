#!/bin/sh
set -e

env

su www-data -s /bin/sh -c './bin/console pim:installer:check-requirements'

wait-for-it.sh $ARTIFAKT_MYSQL_HOST:3306 --timeout=90 -- su www-data -s /bin/sh -c 'sleep 10 && cd /var/www/html/pim-community-standard && APP_ENV=dev php bin/console pim:installer:db --catalog src/Akeneo/Platform/Bundle/InstallerBundle/Resources/fixtures/minimal || :'

su www-data -s /bin/sh -c './bin/console pim:user:create kbeck secretp@ssw0rd kbeck@example.com Kent Beck en_US --admin -n'

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
