FROM python:3.9

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io"

# https://github.com/moby/moby/issues/15025#issuecomment-371799311
ONBUILD ARG AF_ARG_EXPOSE=80
ONBUILD ARG AF_ARG_CMD=sleep
ONBUILD ENV AF_ENV_CMD=${AF_ARG_CMD}

ONBUILD COPY Dockerfile requirements.txt* /usr/src/app/
ONBUILD RUN  if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi
ONBUILD COPY . /usr/src/app

ONBUILD EXPOSE $AF_ARG_EXPOSE

# hadolint ignore=DL3025
ONBUILD CMD $AF_ENV_CMD

