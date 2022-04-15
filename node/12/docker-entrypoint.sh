#!/bin/bash
set -e

if [[ -f "/.artifakt/entrypoint.sh" ]]; then
    source /.artifakt/entrypoint.sh
fi

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- node "$@"
fi

exec "$@"
