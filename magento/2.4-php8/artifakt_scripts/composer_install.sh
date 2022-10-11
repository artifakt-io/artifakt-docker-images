#!/bin/bash

COMPOSER_INSTALL_DEFAULT_ARGUMENTS="--no-cache --no-interaction --no-ansi --no-dev"

if [ -f composer.json ]; then 
    if [ -n "$ARTIFAKT_COMPOSER_INSTALL_CUSTOM_ARGUMENTS" ]; then 
        echo "Using custom arguments for composer install: $ARTIFAKT_COMPOSER_INSTALL_CUSTOM_ARGUMENTS"
        composer install $ARTIFAKT_COMPOSER_INSTALL_CUSTOM_ARGUMENTS
    else
        echo "Using default arguments for composer install: $COMPOSER_INSTALL_DEFAULT_ARGUMENTS"
        composer install $COMPOSER_INSTALL_DEFAULT_ARGUMENTS
    fi
else 
    echo "No composer.json found. It's mandatory to have this file to process the build and deploy. Please, push it to your repository." 
fi