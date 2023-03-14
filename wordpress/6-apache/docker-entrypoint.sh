#!/bin/bash
set -e

if [ -f "/.artifakt/entrypoint.sh" ]; then
  chmod u+x /.artifakt/entrypoint.sh
  echo "Entrypoint.sh script detected and executable - Starting..."
  source /.artifakt/entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
