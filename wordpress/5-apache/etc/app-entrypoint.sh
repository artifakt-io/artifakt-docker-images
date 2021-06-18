#!/bin/bash
set -e

mkdir -p /data/wp-content/uploads /data/wp-content/cache && \
  chown www-data:www-data /data/wp-content/uploads /data/wp-content/cache && \
  ln -sfn /data/wp-content/uploads /var/www/html/wp-content/uploads && \
  ln -sfn /data/wp-content/cache /var/www/html/wp-content/cache
