# from https://raw.githubusercontent.com/docker-library/drupal/master/9.1/php8.0/apache-buster/Dockerfile
FROM registry.artifakt.io/php:8-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

# https://www.drupal.org/node/3060/release
ARG DRUPAL_VERSION=10.0.7
ARG COMPOSER_VERSION=2.1.3

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
	echo 'opcache.memory_consumption=128'; \
	echo 'opcache.interned_strings_buffer=8'; \
	echo 'opcache.max_accelerated_files=4000'; \
	echo 'opcache.revalidate_freq=60'; \
	echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN curl -sS https://getcomposer.org/installer | \
    php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

WORKDIR /opt/drupal

RUN set -eux; \
	export COMPOSER_HOME="$(mktemp -d)"; \
	composer create-project --no-interaction "drupal/recommended-project:${DRUPAL_VERSION}" ./; \
	composer require --no-cache --update-no-dev --prefer-dist --no-ansi --no-interaction drush/drush; \
	chown -R www-data:www-data /opt/drupal web/sites web/modules web/themes; \
	rmdir /var/www/html; \
	ln -sf /opt/drupal/web /var/www/html; \
	# delete composer cache
	rm -rf "$COMPOSER_HOME"

ENV PATH=${PATH}:/opt/drupal/vendor/bin

COPY --chown=www-data:www-data default.settings.php /opt/settings.php

WORKDIR /var/www/html

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
