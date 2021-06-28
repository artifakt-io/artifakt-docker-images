#!/bin/bash
set -e

# Generate file holding custom keys 
if [[ ! -f /data/secret-key ]]; then
  key=$(openssl rand -base64 24)
  echo export WORDPRESS_SECRET=$key >> /data/secret-key
fi

source /data/secret-key

if [[ -x "/.artifakt/entrypoint.sh" ]]; then
    source /.artifakt/entrypoint.sh
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"
