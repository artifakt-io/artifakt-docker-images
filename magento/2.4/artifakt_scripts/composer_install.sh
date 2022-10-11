#!/bin/bash

COMPOSER_INSTALL_DEFAULT_ARGUMENTS="--no-cache --no-interaction --no-ansi --no-dev"

if [ -f composer.json ]; then 
    if [ -f auth.json ]; then cp auth.json /var/www/html/; fi
        if [ -n "$COMPOSER_INSTALL_CUSTOM_ARGUMENTS" ]; then 
            su www-data -s /bin/bash -c "composer install $COMPOSER_INSTALL_DEFAULT_ARGUMENTS $COMPOSER_INSTALL_CUSTOM_ARGUMENTS"
        else
            su www-data -s /bin/bash -c "composer install composer install $COMPOSER_INSTALL_DEFAULT_ARGUMENTS"
        fi
else 
    echo "No composer.json found. It's mandatory to have this file to process the build and deploy. Please, push it to your repository." 
fi