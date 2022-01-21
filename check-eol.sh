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
        if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
            python3 check-eol.py --help
        else
            python3 check-eol.py --distro "$distro" --version "$version" --name "$name" --homepage "$homepage"
        fi
    else
        echo "Plugin corrputed"
        exit 1
    fi
}
