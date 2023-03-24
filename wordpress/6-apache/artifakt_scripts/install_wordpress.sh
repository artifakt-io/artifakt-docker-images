#!/bin/bash
[ "$DEBUG" = "true" ] && set -x

ROOT_PATH="/var/www/html"

#### We determine which version of WordPress to install.
if [ -z "$WORDPRESS_VERSION" ];then WORDPRESS_VERSION="latest"; fi
echo -e "Wordpress version: $WORDPRESS_VERSION"

if [ "$ARTIFAKT_IS_MAIN_INSTANCE" == 1 ]; then
if [ ! -d "/data" ];then mkdir -p /data; fi
	# Generate file holding custom keys 
	[[ ! -f /data/secret-key.php ]] && \
	  echo "<?php " > /data/secret-key.php && \
	  curl https://api.wordpress.org/secret-key/1.1/salt >> /data/secret-key.php && \
	  chown www-data:www-data /data/secret-key.php
fi

#### Creation of the .htaccess file

echo -e "Creation of the .htaccess file in $ROOT_PATH"
cat <<END > /var/www/html/.htaccess
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
END

####
# For the installation of WordPress there are three possibilities: 
# 	- Either it is done by composer and in this case a composer.json and especially a composer.lock must be versioned 
# 	- Either the repository is empty and WordPress must be installed from the official repository (https://wordpress.org)
# 	- Or WordPress has been versioned in its entirety and there are no actions to be taken.
###

### We base ourselves on the existence or non-existence of the wp-includes directory to determine 
### if the core of WordPress is present or not.

if [ ! -d "$ROOT_PATH/wp-includes" ];then
	#### If the wp-includes directory does not exist, we check for the presence or absence of the composer.lock file
	if [ -f "$ROOT_PATH/composer.lock" ]; then
	### If the composer.lock file is found, we proceed with the site installation using composer install
	echo -e "composer.lock file found. Install wordpress with it."
		su www-data -s /bin/bash -c "composer install --prefer-dist"
	else 
	### If we do not find a composer.lock file, we proceed using the official .tar.gz 
	### with the default version 6.1.1 or the version provided through the custom variable $WORDPRESS_VERSION.
		echo -e "No wp-includes folder. Get worpress core from $WORDPRESS_VERSION wordpress version."
	    curl -o $ROOT_PATH/wordpress.tar.gz -fL "https://wordpress.org/wordpress-$WORDPRESS_VERSION.tar.gz";
	    tar -zxvf wordpress.tar.gz 
		rm wordpress.tar.gz
	fi
	cp -R $ROOT_PATH/wordpress/* .
	rm -rf $ROOT_PATH/wordpress
fi

### We grant the necessary permissions in accordance with the official documentation
chown -R www-data:www-data $ROOT_PATH
chmod -R 755 $ROOT_PATH
### Finally remove wp-config-sample.php
if [ -f "$ROOT_PATH/wp-config-sample.php" ];then 
	rm $ROOT_PATH/wp-config-sample.php
fi