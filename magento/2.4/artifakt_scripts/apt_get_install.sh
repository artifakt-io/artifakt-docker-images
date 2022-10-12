#!/bin/bash
echo "CHECKING if more dependencies need to be installed"

if [ -n "$APT_GET_INSTALL" ]; then 
    echo "Dependebies found. Installing $APT_GET_INSTALL"
    apt-get update && apt-get install --fix-missing -yq "$APT_GET_INSTALL" && \
    rm -rf /var/lib/apt/lists/*
    echo "Install done."
else
    echo "No dependencies to add."
fi