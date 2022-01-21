#!/usr/bin/python3
import requests
import json
import sys
import argparse
from datetime import datetime

####                                                                          ####
#                                                                                #
#  Volle Dokumentation: https://github.csom/marekbeckmann/icinga-check-linux-eol  #
#                                                                                #
####                                                                          ####

# STATES
OK = 0
WARNING = 1
CRITICAL = 2
UNKNOWN = 3

# Icinga Message
message = {
    'status': OK,
    'summary': 'Example summary',
    'perfdata': 'label1=0;;;; '
}

# API Check


def check(distribution, distributionVers):
    os_data = requests.get(
        "https://endoflife.date/api/" + distribution + ".json").text
    os_data = json.loads(os_data)
    for el in os_data:
        try:
            match distribution:
                case "debian" | "centos" | "rhel":
                    version = el["latest"]
                case "opensuse":
                    version = el["cycleShortHand"]
            if float(distributionVers) == version:
                present = datetime.now().date()
                eoldate = datetime.strptime(el["eol"], "%Y-%m-%d").date()
                if eoldate > present:
                    status = OK
                    message['summary'] = 'EOL: ' + el["eol"]
                    break
                else:
                    status = CRITICAL
                    message['summary'] = 'EOL: ' + el["eol"]
                    break
            else:
                status = UNKNOWN
                message['summary'] = 'OS Version not in Database'
        except:
            pass
    return status


def args():
    parser = argparse.ArgumentParser(
        prog=sys.argv[0],
        description='Icinga/Nagios EOL Check Script',
        epilog="Thanks for using my Plugin. \nDocumentation: https://github.com/marekbeckmann/icinga-check-linux-eol"
    )

    parser.add_argument(
        "--distro",
        help="Specify the distribution. Make sure it exists in the API",
        required=True,
        action='store',
        type=str
    )

    parser.add_argument(
        "--version",
        help="Specify the exact version of your distribution",
        required=True,
        action='store',
        type=float
    )

    parser.add_argument(
        "--name",
        help="Pretty Name of your distribution",
        action='store',
        type=str
    )

    parser.add_argument(
        "--homepage",
        help="Homepage of your Distribution",
        action='store',
        type=str
    )
    return parser


args = args().parse_args()
distribution = args.distro
distributionVers = args.version
distributionName = args.name
distributionWeb = args.homepage


# Output to Icinga
message['status'] = check(distribution, distributionVers)
try:
    message['summary'] += "\nOS: " + distributionName
    message['summary'] += "\nHomepage: " + distributionWeb
except:
    message['summary'] += "\nOS: Unknown | add --name"
    message['summary'] += "\nHomepage: Unknown | add --web"
print("{summary}".format(
    summary=message.get('summary'),
))
raise SystemExit(message['status'])
