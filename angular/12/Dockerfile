FROM registry.artifakt.io/node:14

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

ARG ANGULAR_VERSION=16.1.0-next.0

RUN npm install -g @angular/cli@${ANGULAR_VERSION}

WORKDIR /var/www/html
