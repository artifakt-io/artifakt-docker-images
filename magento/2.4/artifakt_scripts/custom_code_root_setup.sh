#!/bin/bash

if [ -n "$CUSTOM_CODE_ROOT" ]; then 
    echo "$CUSTOM_CODE_ROOT detected";
    echo "Moving folder to tmp";
    mv -f /var/www/html/"$CUSTOM_CODE_ROOT" /tmp
    ls -lah /tmp/"$CUSTOM_CODE_ROOT"

    echo "Cleaning /var/www/html";
    rm -rf /var/www/html/*
    ls -lah /var/www/html/

    echo "Moving folder to /var/www/html and settings permissions";
    mv -f /tmp/"$CUSTOM_CODE_ROOT"/* /var/www/html/ 
    mv -f /tmp/"$CUSTOM_CODE_ROOT"/.* /var/www/html/ 

    chown -R www-data:www-data /var/www/html  
    ls -lah /var/www/html/
fi