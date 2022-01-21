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
}
