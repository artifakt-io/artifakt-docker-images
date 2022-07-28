FROM golang:1.18-buster

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

RUN mkdir -p /go/src/app && \
	mkdir -p /var/www/ && \
	ln -sfn /go/src/app /var/www/html && \
	chown -R www-data:www-data /go/src/app

WORKDIR /go/src/app

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["app"]
