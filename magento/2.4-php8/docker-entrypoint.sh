#!/bin/bash

[ "$DEBUG" = "true" ] && set -x
if [ -z $ARTIFAKT_ENTRYPOINT_OFF ]; then
  echo "ARTIFAKT_ENTRYPOINT_OFF variable not detected, using Artifakt script artifakt_entrypoint.sh"
  source /artifakt_scripts/artifakt_entrypoint.sh
else
  echo "ARTIFAKT_ENTRYPOINT_OFF variable detected, actions won't be run from Artifakt scripts."
fi

if [ -f "/.artifakt/entrypoint.sh" ]; then
  chmod u+x /.artifakt/entrypoint.sh
  echo "Entrypoint.sh script detected and executable - Starting..."
  source /.artifakt/entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi

exec "$@"
