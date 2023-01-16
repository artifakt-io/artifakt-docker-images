#!/bin/bash
# DI Compile

if [ -n "$MAGENTO_BUILD_DI_COMPILE" ] ; then
    echo "Setup:di:compile"
    php bin/magento setup:di:compile
fi