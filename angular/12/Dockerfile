FROM registry.artifakt.io/node:14

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

ARG ANGULAR_VERSION=14.0.7

RUN npm install -g @angular/cli@${ANGULAR_VERSION}

WORKDIR /var/www/html
