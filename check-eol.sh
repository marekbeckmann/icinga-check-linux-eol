#!/bin/bash

#Wrapper Script for check-eol.py

function get_Params() {
    while test $# -gt 0; do
        case "$1" in
        -h | --help)
            help=true
            exit 0
            ;;
        -d | --dir)
            workingDir="$2"
            ;;
        --*)
            echo "Unknown option $1"
            exit 1
            ;;
        -*)
            echo "Unknown option $1"
            exit 1
            ;;
        esac
        shift
    done
}

function getInfo() {

    . /etc/os-release
    distro=${ID}
    version=${VERSION_ID}
    name=${PRETTY_NAME}
    homepage=${HOME_URL}

    if [[ "$distro" == *"suse"* ]]; then
        distro="opensuse"
    elif [[ "$distro" == *"debian"* ]]; then
        version="$(cat /etc/debian_version)"
    fi
}

function checkStatus() {
    if [[ -f check-eol.py ]]; then
        python3 check-eol.py --distro "$distro" --version "$version" --name "$name" --homepage "$homepage"
    else
        echo "Plugin corrputed"
        exit 1
    fi
}

function init() {
    get_Params "$@"
    if [[ -n "$workingDir" ]]; then
        if [[ "$help" == true ]]; then
            python3 check-eol.py --help
        else
            getInfo
            checkStatus "$@"
        fi
    else
    fi
}

init "$@"
