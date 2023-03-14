#!/bin/bash

if [ -z "$WORDPRESS_VERSION" ]; then WORDPRESS_VERSION="6.1.1"; fi

sha1='80f0f829645dec07c68bcfe0a0a1e1d563992fcb'; 
curl -o wordpress.tar.gz -fL "https://wordpress.org/wordpress-$WORDPRESS_VERSION.tar.gz"; 
echo "$sha1 *wordpress.tar.gz" | sha1sum -c -;

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
tar -xzf wordpress.tar.gz -C /usr/src/;
rm wordpress.tar.gz; 

# https://wordpress.org/support/article/htaccess/
[ ! -e /usr/src/wordpress/.htaccess ];
{ 
	echo '# BEGIN WordPress'; \
	echo ''; \
	echo 'RewriteEngine On'; \
	echo 'RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]'; \
	echo 'RewriteBase /'; \
	echo 'RewriteRule ^index\.php$ - [L]'; \
	echo 'RewriteCond %{REQUEST_FILENAME} !-f'; \
	echo 'RewriteCond %{REQUEST_FILENAME} !-d'; \
	echo 'RewriteRule . /index.php [L]'; \
	echo ''; \
	echo '# END WordPress'; \
} > /usr/src/wordpress/.htaccess;
	
chown -R www-data:www-data /usr/src/wordpress; 
# pre-create wp-content (and single-level children) for folks who want to bind-mount themes, etc so permissions are pre-created properly instead of root:root
# wp-content/cache: https://github.com/docker-library/wordpress/issues/534#issuecomment-705733507
mkdir wp-content;
for dir in /usr/src/wordpress/wp-content/*/ cache; do
dir="$(basename "${dir%/}")";
mkdir "wp-content/$dir";
done;
chown -R www-data:www-data wp-content;
chmod -R 777 wp-content
