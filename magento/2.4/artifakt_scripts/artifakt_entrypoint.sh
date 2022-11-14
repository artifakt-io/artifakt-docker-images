#!/bin/bash
# Author: Aymeric Mathéossian - Head Of Customer Success
# Created: 15/08/2022
# Version: 1.0

set -e
### CONFIGURATION FILES - !! DO NOT EDIT
ROOT_PROJECT="/var/www/html"
NGINX_CONFIG_DEST_FOLDER="/conf/nginxfpm"
NGINX_CONFIG_SRC_FOLDER="$ROOT_PROJECT/.artifakt/nginx"
NGINX_CONFIG_FILES=('custom_global' 'custom_media' 'custom_server_location' 'custom_server' 'custom_upstream' 'default')

VARNISH_CONFIG_DEST_FOLDER="/conf/varnish"
VARNISH_CONFIG_SRC_FOLDER="$ROOT_PROJECT/.artifakt/varnish"
VARNISH_CONFIG_FILES=('custom_backends' 'custom_end_rules' 'custom_process_graphql_headers' 'custom_start_rules' 'custom_vcl_backend_response' 'custom_vcl_deliver' 'custom_vcl_hash' 'custom_vcl_hit' 'custom_vcl_recv' 'default')

PERSISTENT_FOLDER_LIST=('pub/media' 'pub/static/_cache')

MAGENTO_CONFIG_SRC_FOLDER=".artifakt/magento"
MAGENTO_CONFIG_DEST_FOLDER="$ROOT_PROJECT/app/etc"

MAGENTO_MAP_FILE="$NGINX_CONFIG_DEST_FOLDER/custom_http.conf"
MAGENTO_CONFIG_FILE="app/etc/config.php"

MOUNT_ARTIFAKT_LOGS_FOLDER="/var/log/artifakt"
MAGENTO_NATIVE_LOGS_FOLDER=$(pwd)"/var/log"
MAGENTO_LOGS_NATIVE_FILES=('debug.log' 'exception.log' 'system.log')
##########################################

echo "######################################################"
echo "##### MAGENTO OPERATIONS"
echo ""

echo ">> CHECK IF THE DATABASE IS INSTALLED"
tableCount=$(mysql -h $ARTIFAKT_MYSQL_HOST -u $ARTIFAKT_MYSQL_USER -p$ARTIFAKT_MYSQL_PASSWORD $ARTIFAKT_MYSQL_DATABASE_NAME -B -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$ARTIFAKT_MYSQL_DATABASE_NAME';" | grep -v "count");
echo ">>> Number of tables: $tableCount"

if [ "$tableCount" -ne 0 ]; then

  ENV_FILE_CHECK=0
  echo ">> CHECKING THE ENV FILE: $MAGENTO_CONFIG_SRC_FOLDER: env.php.sample"
  if [ -f "$MAGENTO_CONFIG_SRC_FOLDER/env.php.sample" ]
  then
    ENV_FILE_CHECK=1
    cp $MAGENTO_CONFIG_SRC_FOLDER/env.php.sample $MAGENTO_CONFIG_DEST_FOLDER/env.php
    echo "ENV FILE FOUND AND COPIED TO $MAGENTO_CONFIG_DEST_FOLDER/env.php"
  else
    echo "ENV FILE NOT FOUND"
    if [ -f "/artifakt_templates/magento/env.php.sample" ]; then
      echo "COPY SAMPLE ENV FILE FROM /artifakt_templates/ folder"
      cp /artifakt_templates/magento/env.php.sample $MAGENTO_CONFIG_DEST_FOLDER/env.php
      else
      echo "ERROR ! CANNOT FIND THE FILE $MAGENTO_CONFIG_SRC_FOLDER/env.php.sample AND NO TEMPLATE FILE IN BASE CONTAINER"
    fi
  fi

  if [ -f "$MAGENTO_CONFIG_DEST_FOLDER/env.php" ]; then       
    chown www-data:www-data $MAGENTO_CONFIG_DEST_FOLDER/env.php
    ENV_FILE_CHECK=1; 
  fi

  if [ $ENV_FILE_CHECK -eq 1 ]; then

    echo "######################################################"
    echo "##### NGINX CONFIGURATION"
    echo "Src folder: $NGINX_CONFIG_SRC_FOLDER"
    echo "Dest folder: $NGINX_CONFIG_DEST_FOLDER"
    echo ""

    echo ">> CLEANING CONF FOLDER"
    rm -rf $NGINX_CONFIG_DEST_FOLDER/*
    echo ""

    echo ">> GLOBAL CONFIGURATIONS FILE"
    for analyze_nginx_config_file in ${NGINX_CONFIG_FILES[@]}; do
      echo "CHECKING: $analyze_nginx_config_file"
      if [ -f "$NGINX_CONFIG_SRC_FOLDER/$analyze_nginx_config_file.conf" ]; then
        echo "FILE DETECTED - COPY TO CONF FOLDER"
        cp $NGINX_CONFIG_SRC_FOLDER/$analyze_nginx_config_file.conf $NGINX_CONFIG_DEST_FOLDER/
      else
        echo "FILE NOT DETECTED - CREATING EMPTY FILE IN CONF FOLDER"
        touch $NGINX_CONFIG_DEST_FOLDER/$analyze_nginx_config_file.conf
      fi
    done
    echo ""
    echo ">> MULTI-STORE MAP FILE CONFIGURATION"
    echo "Info: if you want to use multi-store, add environment variables named MAP_WEBSITE1, MAP_WEBSITE2"
    echo "Info: MAGENTO_MAP_DEFAULT environement variable is mandatory"
    echo "_________________________________________________________________________________________________"
    echo "Example of environment variables: "
    echo "name: MAGENTO_MAP_WEBSITE1 / value: website1-trainingsessions-beigegerbil-9gsao.artifakt.dev wb1"
    echo "name MAGENTO_MAP_WEBSITE2 / value: website2-trainingsessions-beigegerbil-9gsao.artifakt.dev wb2"
    echo "name: MAGENTO_MAP_WEBSITE3 / value: website3-trainingsessions-beigegerbil-9gsao.artifakt.dev wb3"
    echo "name: MAGENTO_MAP_DEFAULT / value: wb0"
    echo "_________________________________________________________________________________________________"
    echo ""
    if [ ! -z $MAGENTO_RUN_CODE_DEFAULT ]; then
        echo "MAGENTO_RUN_CODE_DEFAULT environment variable found, creating the custom_http.conf file for multi-store"
        echo "# Following code is included in the http block of Nginx" > $MAGENTO_MAP_FILE
        echo "map \$http_host \$MAGE_RUN_CODE" >> $MAGENTO_MAP_FILE
        echo "{" >> $MAGENTO_MAP_FILE
        echo "   default $MAGENTO_RUN_CODE_DEFAULT;" >> $MAGENTO_MAP_FILE
        for var in "${!MAGENTO_RUN_CODE_WEBSITE@}"; do
          echo "   ${!var};" >> $MAGENTO_MAP_FILE
        done
        echo "}" >> $MAGENTO_MAP_FILE

        if [ ! -z "$MAGENTO_RUN_TYPE1" ]; then
          echo "MAGENTO_RUN_TYPE1 variable found, adding info to $MAGENTO_MAP_FILE"
          echo "" >> $MAGENTO_MAP_FILE
          echo "map \$http_host \$MAGE_RUN_TYPE" >> $MAGENTO_MAP_FILE
          echo "{" >> $MAGENTO_MAP_FILE
          for var in "${!MAGENTO_RUN_TYPE@}"; do
            echo "   ${!var};" >> $MAGENTO_MAP_FILE
          done
          echo "}" >> $MAGENTO_MAP_FILE
        fi

        if [ -f $MAGENTO_MAP_FILE ]; then echo "$MAGENTO_MAP_FILE has been generated successfully"; else echo "Error while generating $MAGENTO_MAP_FILE"; fi
        
        if [ ! -f  $NGINX_CONFIG_SRC_FOLDER/custom_server_location.conf ]; then
          echo "Creation of the file custom_server_location.conf"
          echo "# Following code is included in the “location” block of main server block" > $NGINX_CONFIG_DEST_FOLDER/custom_server_location.conf
          echo "fastcgi_param HTTPS \"on\";"  >> $NGINX_CONFIG_DEST_FOLDER/custom_server_location.conf
          if [ -z "$MAGE_RUN_TYPE" ]; then
            MAGE_RUN_TYPE="website" 
          fi
          if [ -n "$MAGE_RUN_TYPE" ]; then echo "fastcgi_param MAGE_RUN_TYPE \"$MAGE_RUN_TYPE\";" >> $NGINX_CONFIG_DEST_FOLDER/custom_server_location.conf; else echo "fastcgi_param MAGE_RUN_TYPE \$MAGE_RUN_TYPE;"  >> $NGINX_CONFIG_DEST_FOLDER/custom_server_location.conf; fi
          if [ -n "$MAGE_RUN_CODE" ]; then echo "fastcgi_param MAGE_RUN_CODE \"$MAGE_RUN_CODE\";" >> $NGINX_CONFIG_DEST_FOLDER/custom_server_location.conf; else echo "fastcgi_param MAGE_RUN_CODE \$MAGE_RUN_CODE;" >> $NGINX_CONFIG_DEST_FOLDER/custom_server_location.conf; fi
        else
          echo "File $NGINX_CONFIG_SRC_FOLDER/custom_server_location.conf, automated creation not done "
        fi

        if [ -f $NGINX_CONFIG_SRC_FOLDER/map_custom.txt ]; then
          echo "Additionnal map file custom config found $NGINX_CONFIG_SRC_FOLDER/map_custom.txt, adding content to $MAGENTO_MAP_FILE" 
          cat $NGINX_CONFIG_SRC_FOLDER/map_custom.txt >> $MAGENTO_MAP_FILE
        fi

        #echo "Removing all old map files"
        #rm $NGINX_CONFIG_DEST_FOLDER/*.map
        count=`ls -1 .artifakt/nginx/*.map 2>/dev/null | wc -l`
        if [ $count -gt 0 ]
        then 
          echo "Copying all .map files to $NGINX_CONFIG_DEST_FOLDER"
          cp $NGINX_CONFIG_SRC_FOLDER/*.map $NGINX_CONFIG_DEST_FOLDER/
        fi 
    else
        echo "No MAGENTO_RUN_CODE_DEFAULT variable found. No action."
        touch $MAGENTO_MAP_FILE
        touch $NGINX_CONFIG_DEST_FOLDER/custom_server_location.conf
    fi
    echo ""

        # MULTI-STORE AUTO GENERATION FROM DATABASE
    echo ">> MULTI-STORE MAP FILE CONFIGURATION FROM DATABASE"
    echo "> To deactivate this auto-generation, set the MAGENTO_MULTISTORE_GEN_OFF variable or set your own variables (MAGENTO_RUN_CODE_DEFAULT)"
    if [ ! -z $MAGENTO_MULTISTORE_GEN_ON ]; then
      echo "> MAGENTO_MULTISTORE_GEN_ON: detected"
      echo "## Preparing the MAGE_RUN_CODE part"
      echo "Request on the database ..."
      result=$(mysql -u $ARTIFAKT_MYSQL_USER -h $ARTIFAKT_MYSQL_HOST -p$ARTIFAKT_MYSQL_PASSWORD $ARTIFAKT_MYSQL_DATABASE_NAME -A -e "select ccd.scope,sw.code,ccd.value from store_website as sw left join core_config_data as ccd on sw.website_id=ccd.scope_id where ccd.path='web/unsecure/base_url' or ccd.path='web/secure/base_url' group by ccd.value, sw.code, ccd.scope" | sed "s/'/\'/;s/\t/ /g;s/^//;s/$//;s/\n//g")
      echo "Initializing the map file: $MAGENTO_MAP_FILE"
      echo "# Following code is included in the http block of Nginx" > $MAGENTO_MAP_FILE
      echo "map \$http_host \$MAGE_RUN_CODE" >> $MAGENTO_MAP_FILE
      echo "{" >> $MAGENTO_MAP_FILE

      while IFS= read -r line; do
          IFS=', ' read -r -a array <<< "$line"
          
          if [ "${array[0]}" == "default" ]; then
              echo "  default ${array[1]};" >> $MAGENTO_MAP_FILE
              echo "New line: default ${array[1]};"
          elif [ "${array[2]}" != "value" ]; then
              shortUrl=$(echo ${array[2]}|sed 's/https\?:\/\///' | sed 's/\///')
              if ! grep -q $shortUrl "$MAGENTO_MAP_FILE"; then
                  echo "  $shortUrl ${array[1]};"  >> $MAGENTO_MAP_FILE
                  echo "New line: $shortUrl ${array[1]};"
              fi
          fi
      done <<< "$result"
      echo "}" >> $MAGENTO_MAP_FILE

      echo "" >> $MAGENTO_MAP_FILE

      MAGENTO_MAP_FILE2=custom_http2.conf
      echo "## Preparing the MAGE_RUN_TYPE part"
      echo "map \$http_host \$MAGE_RUN_TYPE" >> $MAGENTO_MAP_FILE2
      echo "{" >> $MAGENTO_MAP_FILE2

      while IFS= read -r line; do
          IFS=', ' read -r -a array <<< "$line"
          if [ "${array[2]}" != "value" ]; then
              if [ "${array[0]}" != "default" ]; then
                  shortUrl=$(echo ${array[2]}|sed 's/https\?:\/\///' | sed 's/\///')
                  if ! grep -q $shortUrl "$MAGENTO_MAP_FILE2"; then
                      if [ "${array[0]}" == "websites" ]; then
                          storetype="website"
                      elif [ "${array[0]}" == "stores" ]; then
                          storetype="store"
                      fi
                      echo "  $shortUrl $storetype; "  >> $MAGENTO_MAP_FILE2
                      echo "New line: $shortUrl $storetype;"
                  fi
              fi
          fi
      done <<< "$result"
      echo "}" >> $MAGENTO_MAP_FILE2

      cat $MAGENTO_MAP_FILE2 >> $MAGENTO_MAP_FILE
      rm $MAGENTO_MAP_FILE2
    else
      echo "> Multi-store generation deactivated"
    fi
    # END OF MULTI-STORE AUTO GENERATION FROM DATABASE

    echo ">> Content of configuration folders $NGINX_CONFIG_DEST_FOLDER"
    ls -la $NGINX_CONFIG_DEST_FOLDER

    echo ""
    echo ""
    echo "######################################################"
    echo "##### VARNISH CONFIGURATION"

    echo "Src folder: $VARNISH_CONFIG_SRC_FOLDER"
    echo "Dest folder: $VARNISH_CONFIG_DEST_FOLDER"
    echo ""

    echo ">> CLEANING CONF FOLDER"
    rm -rf $VARNISH_CONFIG_DEST_FOLDER/*
    echo ""

    echo ">> GLOBAL CONFIGURATIONS FILE"
    for analyze_varnish_config_file in ${VARNISH_CONFIG_FILES[@]}; do
      echo "CHECKING: $analyze_varnish_config_file.vcl"
      if [ -f "$VARNISH_CONFIG_SRC_FOLDER/$analyze_varnish_config_file.vcl" ]; then
        echo "FILE DETECTED - COPY TO CONF FOLDER"
        cp $VARNISH_CONFIG_SRC_FOLDER/$analyze_varnish_config_file.vcl $VARNISH_CONFIG_DEST_FOLDER/
      else
        echo "FILE NOT DETECTED - CREATING EMPTY FILE IN CONF FOLDER"
        touch $VARNISH_CONFIG_DEST_FOLDER/$analyze_varnish_config_file.vcl
      fi
    done

    echo ">> Content of configuration folders $VARNISH_CONFIG_DEST_FOLDER"
    ls -la $VARNISH_CONFIG_DEST_FOLDER

    echo ""
    echo "######################################################"
    echo "##### Files mapping CONFIGURATION"
    echo ""

    # Improvment
    #echo "DEBUG: waiting for database to be available..."
    #wait-for $ARTIFAKT_MYSQL_HOST:3306 --timeout=90 -- echo "Mysql is up, proceeding with starting sequence"

    for persistent_folder in ${PERSISTENT_FOLDER_LIST[@]}; do

      echo Init persistent folder /data/$persistent_folder
      mkdir -p /data/$persistent_folder

      echo Copy modified/new files from container /var/www/html/$persistent_folder to volume /data/$persistent_folder
      if [ $ARTIFAKT_IS_MAIN_INSTANCE -eq 1 ]; then
        if [ "$persistent_folder" != "pub/media" ]; then
          rsync -rtv /var/www/html/$persistent_folder/ /data/$persistent_folder || true
        fi
      fi

      echo Link /data/$persistent_folder directory to /var/www/html/$persistent_folder
      rm -rf /var/www/html/$persistent_folder && \
        mkdir -p /var/www/html && \
        ln -sfn /data/$persistent_folder /var/www/html/$persistent_folder
        
      #find /var/www/html/$persistent_folder -not -user www-data -not -group www-data | parallel -j 32 chown -R www-data:www-data {} 
      #find /data/$persistent_folder -not -user www-data -not -group www-data | parallel -j 32 chown -R www-data:www-data {}
    done

    ## config.php CHECKING
    echo ""
    echo "######################################################"
    echo "##### config.php CHECKING"
    echo ""

    if [ ! -f "$MAGENTO_CONFIG_DEST_FOLDER/config.php" ]; then 
      echo "File not found, running generation."
      su www-data -s /bin/bash -c "php bin/magento module:enable --all"
      echo "Looking for the $MAGENTO_CONFIG_FILE file for static generation"
    else 
      echo "File already exists."
    fi

    if [ -f "$MAGENTO_CONFIG_FILE" ]; then
      echo "Config file found"
      checkScopes=""
      checkThemes=""
      checkScopes=$(grep "'scopes' => " "$MAGENTO_CONFIG_FILE")
      checkThemes=$(grep "'themes' => " "$MAGENTO_CONFIG_FILE")
      if [ -z "$checkScopes" ] && [ -z "$checkThemes" ]; then 
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

          if [ -n "$ARTIFAKT_MAGE_STATIC_THEME" ]; then
            for currentTheme in ${ARTIFAKT_MAGE_STATIC_THEME[@]}; do
                su www-data -s /bin/bash -c "php bin/magento setup:static-content:deploy -f --no-interaction --jobs ${ARTIFAKT_MAGE_STATIC_JOBS:-5}  --content-version=${ARTIFAKT_BUILD_ID} --theme=$currentTheme ${ARTIFAKT_MAGE_LANG:-all}"
            done
          else
            su www-data -s /bin/bash -c "php bin/magento setup:static-content:deploy -f --no-interaction --jobs ${ARTIFAKT_MAGE_STATIC_JOBS:-5}  --content-version=${ARTIFAKT_BUILD_ID} --exclude-theme=${ARTIFAKT_MAGE_THEME_EXCLUDE:-none} --exclude-language=${ARTIFAKT_MAGE_LANG_EXCLUDE:-none} ${ARTIFAKT_MAGE_LANG:-all}"
          fi
          set +e
    
          #6 fix owner/permissions on var/{cache,di,generation,page_cache,view_preprocessed}
          echo ">> PERMISSIONS -  Fix owner/permissions on var/{cache,di,generation,page_cache,view_preprocessed}"
          find var generated vendor pub/static pub/media app/etc -type f -exec chown www-data:www-data {} +
          find var generated vendor pub/static pub/media app/etc -type d -exec chown www-data:www-data {} +

          find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
          find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +

          echo ">> PERMISSIONS - Fix owner on dynamic data"
          chown -R www-data:www-data /var/www/html/var/log
          chown -R www-data:www-data /var/www/html/var/page_cache
        else
          echo "MAGE_MODE not set to production. No static generated during entrypoint."
        fi
      else
        echo "No config.php found."
      fi
    fi
    
    ## LOGS SCRIPT START
    echo ""
    echo "######################################################"
    echo "##### LOGS IMPLEMENTATION"
    echo ""
    echo "** LOGS SCRIPT START"

    rm -rf "$MAGENTO_NATIVE_LOGS_FOLDER"
    mkdir -p "$MAGENTO_NATIVE_LOGS_FOLDER"
    mkdir -p "$MOUNT_ARTIFAKT_LOGS_FOLDER"
 
    if [ -z "$CUSTOM_LOGS_FOLDER" ]; then CUSTOM_LOGS_FOLDER=$MAGENTO_NATIVE_LOGS_FOLDER; fi
    chown -R www-data:www-data  "$MOUNT_ARTIFAKT_LOGS_FOLDER" "$CUSTOM_LOGS_FOLDER"
    echo "** Mapping native magento logs"
    for MAGENTO_LOGS_NATIVE_FILE in ${MAGENTO_LOGS_NATIVE_FILES[@]}; do
        echo "** Mapping file: $MAGENTO_LOGS_NATIVE_FILE"
        if [ ! -f "$MOUNT_ARTIFAKT_LOGS_FOLDER"/"$MAGENTO_LOGS_NATIVE_FILE" ]; then
          touch "$MOUNT_ARTIFAKT_LOGS_FOLDER"/"$MAGENTO_LOGS_NATIVE_FILE"
        fi
        ln -sfn "$MOUNT_ARTIFAKT_LOGS_FOLDER/$MAGENTO_LOGS_NATIVE_FILE" "$CUSTOM_LOGS_FOLDER"
        chown www-data:www-data "$MOUNT_ARTIFAKT_LOGS_FOLDER/$MAGENTO_LOGS_NATIVE_FILE" "$CUSTOM_LOGS_FOLDER/$MAGENTO_LOGS_NATIVE_FILE"
    done

    echo "** Checking custom magento logs"

    if [ -n "$MAGENTO_LOGS_CUSTOM_FILES" ]; then
        for MAGENTO_LOGS_CUSTOM_FILE in ${MAGENTO_LOGS_CUSTOM_FILES[@]}; do
          echo "** Mapping files: $MAGENTO_LOGS_CUSTOM_FILE"
          if [ ! -f "$MOUNT_ARTIFAKT_LOGS_FOLDER"/"$MAGENTO_LOGS_CUSTOM_FILE" ]; then
            touch "$MOUNT_ARTIFAKT_LOGS_FOLDER"/"$MAGENTO_LOGS_CUSTOM_FILE"
          fi
          ln -sfn "$MOUNT_ARTIFAKT_LOGS_FOLDER/$MAGENTO_LOGS_CUSTOM_FILE" "$CUSTOM_LOGS_FOLDER"
          chown www-data:www-data "$MOUNT_ARTIFAKT_LOGS_FOLDER/$MAGENTO_LOGS_CUSTOM_FILE" "$CUSTOM_LOGS_FOLDER/$MAGENTO_LOGS_CUSTOM_FILE"
      done
    fi

    
    ## LOGS SCRIPT END
    
    echo ""
    echo "######################################################"
    echo "##### LOGS SCRIPT END"
    echo ""

    # Update database and/or configuration if changes
    if [ $ARTIFAKT_IS_MAIN_INSTANCE == 1 ]; then

      # read db and config statuses 
      # while temporary disabling errors
      echo ">> STARTING DATABASE OPERATIONS"
      set +e
      bin/magento setup:db:status
      dbStatus=$?
      bin/magento app:config:status
      configStatus=$?
      set -e

      echo "> Result of setup:db:status : $dbStatus"
      echo "> Result of app:config:status : $configStatus"
      
      if [[ $dbStatus == 2 || $configStatus == 2 ]];then
        echo "Put 'current/live' release under maintenance"
        set -e
        su www-data -s /bin/bash -c "php bin/magento maintenance:enable"
        set +e
        echo "=> Maintenance enabled."
      fi

      if [ "$(bin/magento app:config:status)" != "Config files are up to date." ]; then      
          echo "Configuration needs app:config:import";
          su www-data -s /bin/bash -c "php bin/magento app:config:import --no-interaction"
          echo "=> Configuration is now up to date.";
      else
          echo "=> Configuration is already up to date.";
      fi

      
      if [ $dbStatus == 2 ]; then
        set -e
        echo "The database needs to be updated"
        echo "=> Running setup:db-schema:upgrade"
        su www-data -s /bin/bash -c "php bin/magento setup:db-schema:upgrade --no-interaction"
        echo "=> Running setup:db-data:upgrade"
        su www-data -s /bin/bash -c "php bin/magento setup:db-data:upgrade --no-interaction"
        set +e
      fi

      echo "Remove 'current/live' release under maintenance"
      if [[ $dbStatus == 2 || $configStatus == 2 ]];    then
        set -e
        su www-data -s /bin/bash -c "php bin/magento maintenance:disable"
        echo "=> Maintenance disabled"   
        set +e
      fi

      echo ">> END OF DATABASE OPERATIONS"
      if [ -z $MAGE_MODE ]; then 
        MAGE_MODE="production"
      fi
      
      if [ "$MAGE_MODE" != "production" ]; then
        echo "!> DEVELOPER MODE DETECTED - SWITCH"
        su www-data -s /bin/bash -c "bin/magento deploy:mode:set developer"
      fi
    else
      echo ">> DB UPDATE: WAITING FOR THE DB TO BE READY (ACTIONS DONE ON MAIN INSTANCE)"
      until bin/magento setup:db:status && bin/magento app:config:status
      do
        echo "The main instance is not ready..."
        sleep 10
      done
    fi # end of "Update database and/or configuration if changes"

    if [ ! -z $ARTIFAKT_REPLICA_LIST ]; then 
      if [ -z $SET_VARNISH ]; then
        echo "VARNISH / env.php - ENABLE VARNISH AS CACHE BACKEND"
        echo "REPLICA LIST: $ARTIFAKT_REPLICA_LIST"
        echo "INFO: You can deactivate this by setting the SET_VARNISH to 0 (or anything you want)"
        echo "Activating Varnish in env.php file"
        su www-data -s /bin/bash -c "php bin/magento config:set --scope=default --scope-code=0 system/full_page_cache/caching_application 2"
        su www-data -s /bin/bash -c "php bin/magento setup:config:set --http-cache-hosts=${ARTIFAKT_REPLICA_LIST} --no-interaction;"
      fi
    fi

    # Fix autoload error
    chown www-data:www-data /var/www/html/var/vendor/autoload.php
    chmod 755 /var/www/html/var/vendor/autoload.php

    # Copy all files in shared folder to allow nginx to access it
    if [ $ARTIFAKT_IS_MAIN_INSTANCE -eq 1 ]; then
      echo ">> COPY FILES FOR NGINX: statics, js and files in pub"
      echo "Create /data/pub if it doesn't exist"
      mkdir -p /data/pub
      echo "Switch owner to www-data"
      chown www-data:www-data /data/pub
      #echo "Copy all changed files from /var/www/html/pub/static/* to /data/pub/static"
      if [ -d /var/www/html/pub/static ]; then rsync -rtv /var/www/html/pub/static/ /data/pub/static/; fi
      if [ -d /var/www/html/pub/js ]; then rsync -rtv /var/www/html/pub/js/* /data/pub/js; fi
      echo "Copy all files in pub (no subdirectories)"
      rsync -rtv ./pub/* /data/pub/
    fi
  else
    echo "ERROR - NO ENV FILE, MAGENTO OPERATIONS SKIPPED"
  fi # end of actions if env file exists
else
  echo "ERROR - MAGENTO IS NOT INSTALLED YET (NO TABLES FOUND)"
fi # end of actions if Magento is installed


