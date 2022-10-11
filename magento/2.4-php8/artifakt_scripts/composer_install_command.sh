#!/bin/bash

COMPOSER_INSTALL_DEFAULT_ARGUMENTS="--no-cache --no-interaction --no-ansi --no-dev"

if [ -z "$ARTIFAKT_COMPOSER_VERSION" ]; then ARTIFAKT_COMPOSER_VERSION="2.3.7"; fi
curl -sS https://getcomposer.org/installer | \
  php -- --version="${ARTIFAKT_COMPOSER_VERSION}" --install-dir=/usr/local/bin --filename=composer

if [ -f composer.lock ]; then 
    if [ -n "$COMPOSER_INSTALL_CUSTOM_ARGUMENTS" ]; then 
        su www-data -s /bin/bash -c "composer install $COMPOSER_INSTALL_DEFAULT_ARGUMENTS $COMPOSER_INSTALL_CUSTOM_ARGUMENTS"
    else
        su www-data -s /bin/bash -c "composer install composer install $COMPOSER_INSTALL_DEFAULT_ARGUMENTS"
    fi
else 
    echo "No composer.lock found. It's mandatory to have this file to process the build and deploy. Please, push it to your repository." 
fi
