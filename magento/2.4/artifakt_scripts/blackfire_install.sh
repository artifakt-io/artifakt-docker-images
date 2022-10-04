#!/bin/sh

echo ">> CHECKING IF BLACKFIRE HAS TO BE INSTALLED"
echo "INFO: to deploy blackfire, set these variables: BLACKFIRE_SERVER_ID, BLACKFIRE_SERVER_TOKEN"
echo ""
if [ -n "$BLACKFIRE_SERVER_ID" ] && [ -n "$BLACKFIRE_SERVER_TOKEN" ]; then
    echo "BLACKFIRE_SERVER_ID, BLACKFIRE_SERVER_TOKEN found"
    echo "BLACKFIRE_SERVER_ID: $BLACKFIRE_SERVER_ID"
    echo "BLACKFIRE_SERVER_TOKEN: $BLACKFIRE_SERVER_TOKEN"
    echo "Blackfire installation started"

    wget -q -O - https://packages.blackfire.io/gpg.key | sudo dd of=/usr/share/keyrings/blackfire-archive-keyring.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/blackfire-archive-keyring.asc] http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list && \
    apt update && \
    apt install -yq blackfire blackfire-php  && \
    blackfire agent:config --no-interaction --server-id="${BLACKFIRE_SERVER_ID}" --server-token="${BLACKFIRE_SERVER_TOKEN}"
    service blackfire-agent restart
    echo "Blackfire installation finished"
else
    echo "Variables not found, Blackfire won't be deployed."
fi



