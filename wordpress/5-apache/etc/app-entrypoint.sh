#!/bin/bash
set -e

mkdir -p /data/wp-content/uploads && \
  chown www-data:www-data /data/wp-content/uploads && \
  ln -sfn /data/wp-content/uploads /var/www/html/wp-content/uploads
