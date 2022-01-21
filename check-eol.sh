#!/bin/bash

#Wrapper Script for check-eol.py

function getInfo() {

    . /etc/os-release
    distro=${ID}
    version=${VERSION_ID}
    name=${PRETTY_NAME}
    homepage=${HOME_URL}

}

function checkStatus() {
    if [[ distro == *"debian"* ]]; then
        version="$(cat /etc/debian_version)"
    fi
    if [[ -f check-eol.py ]]; then
        python3 check-eol.py --distro "$distro" --version "$version" --name "$name" --homepage "$homepage"
    else
        echo "Plugin corrputed"
        exit 1
    fi
}
