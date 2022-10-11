#!/bin/bash

if [ -z "$ARTIFAKT_COMPOSER_VERSION" ]; then ARTIFAKT_COMPOSER_VERSION="2.3.7"; fi
curl -sS https://getcomposer.org/installer | \
  php -- --version="${ARTIFAKT_COMPOSER_VERSION}" --install-dir=/usr/local/bin --filename=composer