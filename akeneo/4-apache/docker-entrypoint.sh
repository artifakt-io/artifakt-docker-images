#!/bin/bash
set -e

# bind-mounted volume needs init here
# see custom persistent folders in configmaps
su www-data -s /bin/sh -c "mkdir -p /data/var"

if [ -x "/.artifakt/entrypoint.sh" ]; then
    source /.artifakt/entrypoint.sh
fi

su www-data -s /bin/sh -c './bin/console pim:installer:check-requirements'

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"