FROM python:3.9

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD [ "python" ]

