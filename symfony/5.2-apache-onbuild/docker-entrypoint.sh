#!/bin/sh

[ "$DEBUG" = "true" ] && set -x

if [ -f /.artifakt/entrypoint.sh ]; then
	/.artifakt/entrypoint.sh;
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
