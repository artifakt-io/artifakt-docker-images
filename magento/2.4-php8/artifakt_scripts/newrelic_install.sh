#!/bin/sh

echo ">> CHECKING IF NEWRELIC HAS TO BE INSTALLED"
echo "INFO: to deploy newrelic, set these variables: NEWRELIC_KEY, NEWRELIC_APPNAME, NEWRELIC_VERSION"
echo ""
if [ ! -z $NEWRELIC_KEY ] && [ ! -z $NEWRELIC_APPNAME ] && [ ! -z $NEWRELIC_VERSION ]; then
    echo "NEWRELIC_KEY, NEWRELIC_APPNAME, NEWRELIC_VERSION found"
    echo "NEWRELIC_KEY: $NEWRELIC_KEY"
    echo "NEWRELIC_APPNAME: $NEWRELIC_APPNAME"
    echo "NEWRELIC_VERSION: $NEWRELIC_VERSION"
    echo "Newrelic installation started"
    curl -L https://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/newrelic-php5-${NEWRELIC_VERSION}-linux.tar.gz | tar -C /tmp -zx
    export NR_INSTALL_SILENT=true
    /tmp/newrelic-php5-${NEWRELIC_VERSION}-linux/newrelic-install install && \
    sed -i \
    -e 's/"REPLACE_WITH_REAL_KEY"/'$NEWRELIC_KEY'/' \
    -e 's/newrelic.appname =.*/newrelic.appname = '$NEWRELIC_APPNAME'/' \
    /usr/local/etc/php/conf.d/newrelic.ini
    chown www-data:www-data /var/log/newrelic
    echo "Newrelic installation finished"
else
    echo "Variables not found, NewRelic won't be deployed."
fi