FROM registry.artifakt.io/node:14

LABEL vendor="Artifakt" \
      author="remi@artifakt.io" \
      stage="alpha"

ARG ANGULAR_VERSION=16.0.0-next.3

RUN npm install -g @angular/cli@${ANGULAR_VERSION}

WORKDIR /var/www/html
