FROM node:18-buster

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="ga"

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD [ "npm", "start" ]
