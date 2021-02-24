FROM python:3.9

LABEL vendor="Artifakt.io" \
      author="djalal@artifakt.io"

ONBUILD WORKDIR /usr/src/app
ONBUILD COPY requirements.txt .
ONBUILD RUN pip install --no-cache-dir -r requirements.txt
ONBUILD COPY . .
