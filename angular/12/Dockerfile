FROM registry.artifakt.io/node:14

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

ARG ANGULAR_VERSION=12.2.16

RUN npm install -g @angular/cli@${ANGULAR_VERSION}

WORKDIR /var/www/html
