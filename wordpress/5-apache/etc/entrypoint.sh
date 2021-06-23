#!/bin/bash
set -e

# Generate file holding custom keys 
[[ ! -f /data/secret-key.php ]] && \
  echo "<?php " > /data/secret-key.php && \
  curl https://api.wordpress.org/secret-key/1.1/salt >> /data/secret-key.php && \
  chown www-data:www-data /data/secret-key.php

# Mount upload directory
mkdir -p /data/wp-content/uploads && \
  chown www-data:www-data /data/wp-content/uploads && \
  ln -sfn /data/wp-content/uploads /var/www/html/wp-content/uploads

# Mount cache directory
mkdir -p /data/wp-content/cache && \
  chown www-data:www-data /data/wp-content/cache && \
  ln -sfn /data/wp-content/cache /var/www/html/wp-content/cache

# Uncomment to mount plugins directory if you don't version them
#mkdir -p /data/wp-content/plugins && \
#  chown www-data:www-data /data/wp-content/plugins && \
#  ln -sfn /data/wp-content/plugins /var/www/html/wp-content/plugins

# Uncomment to mount themes directory if you don't version them
#mkdir -p /data/wp-content/themes && \
#  chown www-data:www-data /data/wp-content/themes && \
#  ln -sfn /data/wp-content/themes /var/www/html/wp-content/themes
