#!/bin/bash
set -e

# Generate file holding custom keys 
[[ ! -f /data/secret-key.php ]] && \
  echo "<?php " > /data/secret-key.php && \
  curl https://api.wordpress.org/secret-key/1.1/salt >> /data/secret-key.php && \
  chown www-data:www-data /data/secret-key.php

# Mount upload directory
rm -rf /var/www/html/wp-content/uploads && \
  mkdir -p /data/wp-content/uploads && \
  ln -sfn /data/wp-content/uploads /var/www/html/wp-content/uploads && \
  chown -h www-data:www-data /var/www/html/wp-content/uploads /data/wp-content/uploads

# Mount cache directory
rm -rf /var/www/html/wp-content/cache && \
  mkdir -p /data/wp-content/cache && \
  ln -sfn /data/wp-content/cache /var/www/html/wp-content/cache && \
  chown -h www-data:www-data /var/www/html/wp-content/cache /data/wp-content/cache
  
# Uncomment to mount plugins directory if you don't version them
#rm -rf /var/www/html/wp-content/plugins && \
#  mkdir -p /data/wp-content/plugins && \
#  ln -sfn /data/wp-content/plugins /var/www/html/wp-content/plugins && \
#  chown -h www-data:www-data /var/www/html/wp-content/plugins /data/wp-content/plugins

# Uncomment to mount themes directory if you don't version them
#rm -rf /var/www/html/wp-content/themes && \
#  mkdir -p /data/wp-content/themes && \
#  ln -sfn /data/wp-content/themes /var/www/html/wp-content/themes && \
#  chown www-data:www-data /var/www/html/wp-content/themes /data/wp-content/themes
