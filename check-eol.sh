#!/bin/bash

#Wrapper Script for check-eol.py

function get_Params() {
    while test $# -gt 0; do
        case "$1" in
        -h | --help)
            helpMsg
            ;;
        -d | --dir)
            workingDir="$2"
            ;;
        --http_proxy)
            httpProxy="$2"
            ;;
        --https_proxy)
            httpsProxy="$2"
            ;;
        --*)
            echo "Unknown option $1"
            exit 2
            ;;
        -*)
            echo "Unknown option $1"
            exit 2
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
        python3 check-eol.py --distro "$distro" --version "$version" --name "$name" --homepage "$homepage" --http_proxy "$httpProxy" --https_proxy "$httpsProxy"
    else
        echo "Plugin corrputed"
        exit 2
    fi
}

function helpMsg() {
    printf "
usage: check-eol.py [-h] --distro DISTRO --version VERSION [--name NAME] [--homepage HOMEPAGE]

Icinga/Nagios EOL Check Script

optional arguments:
  -h, --help           show this help message and exit
  --distro DISTRO      Specify the distribution. Make sure it exists in the API
  --version VERSION    Specify the exact version of your distribution
  --name NAME          Pretty Name of your distribution
  --homepage HOMEPAGE  Homepage of your Distribution
  --http_proxy PROXY   HTTP Proxy
  --https_Proxy PROXY  HTTPS Proxy
Thanks for using my Plugin. Documentation: https://github.com/marekbeckmann/icinga-check-linux-eol
"
    exit 3
}

function init() {
    get_Params "$@"
    if [[ -n "$workingDir" ]]; then
        cd "$workingDir" || exit 2
    else
        cd "$(dirname "$0")" || exit 2
    fi
    getInfo
    checkStatus
}

init "$@"
#Test
