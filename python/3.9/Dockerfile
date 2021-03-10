FROM python:3.9

LABEL vendor="Artifakt.io" \
      author="djalal@artifakt.io"

# https://github.com/moby/moby/issues/15025#issuecomment-371799311
ONBUILD ARG AF_ARG_EXPOSE=80
ONBUILD ARG AF_ARG_CMD=sleep
ONBUILD ENV AF_ENV_CMD=${AF_ARG_CMD}

ONBUILD WORKDIR /usr/src/app
ONBUILD COPY Dockerfile requirements.txt* ./
ONBUILD RUN  if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi
ONBUILD COPY . .

ONBUILD EXPOSE $AF_ARG_EXPOSE
ONBUILD CMD $AF_ENV_CMD
