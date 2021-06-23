FROM wordpress:5-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"
      
HEALTHCHECK CMD curl --fail http://localhost || exit 1

# Force HTTPS on mode
ENV HTTPS=on

# hadolint ignore=SC2016
RUN echo 'SetEnv HTTPS on' > /etc/apache2/conf-enabled/force-ssl.conf

# Install composer
ARG COMPOSER_VERSION=1.10.22
RUN curl -sS https://getcomposer.org/installer | \
    php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

# Install WP CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# hadolint ignore=DL3045
# Add default configuration files
COPY --chown=www-data:www-data etc/wp-config.php /var/www/html/
COPY etc/entrypoint.sh /.artifakt/

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
