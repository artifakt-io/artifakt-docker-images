FROM python:3.9

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io"

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD [ "python" ]
