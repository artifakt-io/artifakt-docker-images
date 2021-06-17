#!/bin/bash
set -e

if [[ -x "/.artifakt/entrypoint.sh" ]]; then
    source /.artifakt/entrypoint.sh
fi

# inject dotenv conf file
[[ ! -f /data/sites/default/settings.php && -f /opt/settings.php ]] && \
  echo "first install, found a mounted conf file, copying it to default path" && \
  mkdir -p /data/sites/default && \
  cp /opt/settings.php /data/sites/default/settings.php

# move config to persistent data folder
[[ ! -d /data/config/sync ]] && \
  mkdir -p /data/config/sync && \
  ls -la /data/config

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
