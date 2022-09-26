#!/bin/bash

[ "$DEBUG" = "true" ] && set -x
if [[ -n $ENTRYPOINT_CUSTOM ]]; then
  if [[ -x "/.artifakt/entrypoint.sh" ]]; then
    source /.artifakt/entrypoint.sh
  fi
else
    source artifakt_scripts/artifakt_entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

exec "$@"
