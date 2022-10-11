#!/bin/bash

if [ -z "$ARTIFAKT_COMPOSER_AUTOLOAD_OFF" ];then
    echo "ARTIFAKT_COMPOSER_AUTOLOAD_OFF variable not detected, dump-autoload process triggered."
    composer dump-autoload --no-dev --optimize --apcu 
fi
