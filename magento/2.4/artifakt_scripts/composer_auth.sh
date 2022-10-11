#!/bin/bash

if [ -f auth.json ]; then 
    echo "auth.json file detected. Copy in new folder /var/www/html/.composer"
    mkdir -p /var/www/html/.composer  
    cp auth.json /var/www/html/.composer   
    chown -R www-data:www-data /var/www/html/.composer
fi