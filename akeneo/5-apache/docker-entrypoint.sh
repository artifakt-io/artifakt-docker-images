#!/bin/bash
set -e

env

wait-for-it.sh $ARTIFAKT_MYSQL_HOST:3306 --timeout=90 -- su www-data -s /bin/bash -c 'sleep 10 && cd /var/www/html/pim-community-standard && APP_ENV=dev php bin/console pim:installer:db --catalog src/Akeneo/Platform/Bundle/InstallerBundle/Resources/fixtures/minimal || :'

su www-data -s /bin/bash -c './bin/console pim:user:create kbeck secretp@ssw0rd kbeck@example.com Kent Beck en_US --admin -n'

su www-data -s /bin/bash -c './bin/console pim:installer:check-requirements'

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
