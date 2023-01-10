#!/bin/sh

# DEPLOY NVM, YARN, GULP, ...
if [ ! -z $NODE_VERSION ]; then
    echo "NODE - DEPLOYMENT OF NPM VERSION $NODE_VERSION"
    mkdir /var/www/.nvm && chown www-data:www-data /var/www/.nvm && \ 
    mkdir /var/www/.npm && chown www-data:www-data /var/www/.npm && \
    mkdir /var/www/.config && chown www-data:www-data /var/www/.config

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash

    . ~/.nvm/nvm.sh && cp /root/.nvm/nvm.sh /var/www/.nvm/nvm.sh

    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    node --version
    if [ -n "$NODE_MODULES" ]; then
        npm install -g "$NODE_MODULES"
    fi

    chown -R www-data:www-data /var/www/.nvm && \
    chown -R www-data:www-data /var/www/.npm && \
    chown -R www-data:www-data /var/www/.config

    if [ -d "/var/www/node_modules" ]; then
        chown -R www-data:www-data /var/www/node_modules
    fi
    
fi
