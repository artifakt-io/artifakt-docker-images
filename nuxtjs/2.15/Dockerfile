FROM registry.artifakt.io/vuejs:3

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

ARG NUXT_VERSION=2.5.17

WORKDIR /var/www/html
COPY package.json .
RUN npm install --force && chown -R www-data:www-data .

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD [ "npm", "start" ]
