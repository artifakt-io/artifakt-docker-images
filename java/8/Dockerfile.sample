FROM maven:3.6-openjdk-8-slim as maven

WORKDIR /usr/src/app

COPY ./pom.xml ./pom.xml
COPY ./src ./src
RUN mvn dependency:go-offline -B
RUN mvn package

FROM registry.artifakt.io/java:8
WORKDIR /app
COPY --from=maven /usr/src/app/target/* ./
RUN mv *.jar app.jar

# copy the artifakt folder on root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN  if [ -d .artifakt ]; then cp -rp /var/www/html/.artifakt /.artifakt/; fi

# run custom scripts build.sh
# hadolint ignore=SC1091
RUN --mount=source=artifakt-custom-build-args,target=/tmp/build-args \
  if [ -f /tmp/build-args ]; then source /tmp/build-args; fi && \
  if [ -f /.artifakt/build.sh ]; then /.artifakt/build.sh; fi

ENV SPRING_APPLICATION_JSON='{"server.port":80}'

CMD ["java", "-jar", "/app/app.jar"]