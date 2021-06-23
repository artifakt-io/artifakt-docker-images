#!/bin/bash
set -e

mkdir -p /data/wp-content/uploads /data/wp-content/cache && \
  chown www-data:www-data /data/wp-content/uploads /data/wp-content/cache && \
  ln -sfn /data/wp-content/uploads /var/www/html/wp-content/uploads && \
  ln -sfn /data/wp-content/cache /var/www/html/wp-content/cache

# generate file holding custom keys 
[[ ! -f /data/secret-key.php ]] && \
  echo "first install, generating secret keys" && \
  echo "<?php " > /data/secret-key.php && \
  curl https://api.wordpress.org/secret-key/1.1/salt >> /data/secret-key.php && \
  chown www-data:www-data /data/secret-key.php



