FROM node:fermium

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io"

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD [ "npm", "start" ]
