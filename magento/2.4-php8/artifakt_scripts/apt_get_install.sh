#!/bin/bash

echo "CHECKING if more dependencies need to be installed"

if [ -n "$APT_GET_INSTALL" ]; then 
    echo "Depedencies found. Installing $APT_GET_INSTALL"
    apt-get update --fix-missing
    for i in $APT_GET_INSTALL; do
        echo "Install $i"
        sudo apt-get install -y "$i"
    done
    rm -rf /var/lib/apt/lists/*
    echo "Install done."
else
    echo "No dependencies to add."
fi