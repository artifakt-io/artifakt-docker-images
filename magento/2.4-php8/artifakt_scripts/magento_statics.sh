#!/bin/bash

if [ -z $MAGE_MODE ]; then 
    MAGE_MODE="production"
fi

MAGENTO_CONFIG_FILE="app/etc/config.php"

echo "Looking for the $MAGENTO_CONFIG_FILE file for static generation"
if [ -f $MAGENTO_CONFIG_FILE ]; then
    
    if [ -n "$MAGENTO_CONFIG_SET_VALUES" ]; then
        for MAGENTO_CONFIG_SET_VALUE in ${MAGENTO_CONFIG_SET_VALUES[@]}; do
            echo "Set config dev/$MAGENTO_CONFIG_SET_VALUE to 1"
            php bin/magento config:set dev/"$MAGENTO_CONFIG_SET_VALUE" 1
        done
    fi

    echo "Config file found, looking for scope and themes in this file"
        checkScopes=""
        checkThemes=""
        checkScopes=$(grep "'scopes' => " "$MAGENTO_CONFIG_FILE")
        checkThemes=$(grep "'themes' => " "$MAGENTO_CONFIG_FILE")
    
    if [ -n "$MAGENTO_BLOCK_STATICS_IN_BUILD" ]; then
        checkScopes=""
        checkThemes=""
    fi

    if [ ! -z "$checkScopes" ] && [ ! -z "$checkThemes" ]; then 
        echo "Scopes and themes found in the config file"
        if [ "$MAGE_MODE" = "production" ]; then
            echo "!> PRODUCTION MODE DETECTED"
            echo ">> STATIC CONTENT DEPLOY"
            echo "INFO: for each parameter, you have below each Environment Variable you can use to customize the deployment."
            echo "Jobs (ARTIFAKT_MAGE_STATIC_JOBS): ${ARTIFAKT_MAGE_STATIC_JOBS:-5}"
            echo "Content version: $ARTIFAKT_BUILD_ID"
            echo "Theme (ARTIFAKT_MAGE_STATIC_THEME): ${ARTIFAKT_MAGE_STATIC_THEME:-all}"
            echo "Theme excluded (ARTIFAKT_MAGE_THEME_EXCLUDE): ${ARTIFAKT_MAGE_THEME_EXCLUDE:-none}"
            echo "Language excluded (ARTIFAKT_MAGE_LANG_EXCLUDE): ${ARTIFAKT_MAGE_LANG_EXCLUDE:-none}"
            echo "Languages (ARTIFAKT_MAGE_LANG): ${ARTIFAKT_MAGE_LANG:-all}"
            set -e
            
            if [ ! -z "$ARTIFAKT_MAGE_STATIC_THEME" ]; then
                for currentTheme in ${ARTIFAKT_MAGE_STATIC_THEME[@]}; do
                    php bin/magento setup:static-content:deploy -f --no-interaction --jobs ${ARTIFAKT_MAGE_STATIC_JOBS:-5}  --content-version=${ARTIFAKT_BUILD_ID} --theme=$currentTheme ${ARTIFAKT_MAGE_LANG:-all}
                done
            else
                php bin/magento setup:static-content:deploy -f --no-interaction --jobs ${ARTIFAKT_MAGE_STATIC_JOBS:-5}  --content-version=${ARTIFAKT_BUILD_ID} --theme="${ARTIFAKT_MAGE_STATIC_THEME:-all}" --exclude-theme="${ARTIFAKT_MAGE_THEME_EXCLUDE:-none}" --exclude-language="${ARTIFAKT_MAGE_LANG_EXCLUDE:-none}" ${ARTIFAKT_MAGE_LANG:-all}
            fi
            
            set +e
        fi
    fi
else
    echo "No config.php found."
fi