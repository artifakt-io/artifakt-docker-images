#!/bin/bash

${ARTIFAKT_COMPOSER_VERSION:-"2.3.7"} 
curl -sS https://getcomposer.org/installer | \
  php -- --version="${ARTIFAKT_COMPOSER_VERSION}" --install-dir=/usr/local/bin --filename=composer