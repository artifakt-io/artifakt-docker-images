#!/bin/bash

if [ -z "$ARTIFAKT_COMPOSER_AUTOLOAD_OFF" ];then
    php bin/magento setup:di:compile
    echo "ARTIFAKT_COMPOSER_AUTOLOAD_OFF variables not detected, dump-autoload process triggered."
    composer dump-autoload --no-dev --optimize --apcu 
fi
