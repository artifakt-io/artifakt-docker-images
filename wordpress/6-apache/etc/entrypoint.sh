#!/bin/bash
set -e

# Generate file holding custom keys 
[[ ! -f /data/secret-key.php ]] && \
  echo "<?php " > /data/secret-key.php && \
  curl https://api.wordpress.org/secret-key/1.1/salt >> /data/secret-key.php && \
  chown www-data:www-data /data/secret-key.php

