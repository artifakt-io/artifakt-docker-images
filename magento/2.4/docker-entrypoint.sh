#!/bin/bash

[ "$DEBUG" = "true" ] && set -x
if [ -z $ARTIFAKT_ENTRYPOINT_OFF ]; then
  source /artifakt_scripts/artifakt_entrypoint.sh
else
  echo "ARTIFAKT_ENTRYPOINT_OFF variable detected, actions won't be run from Artifakt scripts."
fi

if [ -f "/.artifakt/entrypoint.sh" ]; then
  if [[ -x "/.artifakt/entrypoint.sh" ]]; then
      source /.artifakt/entrypoint.sh
  fi
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

exec "$@"
