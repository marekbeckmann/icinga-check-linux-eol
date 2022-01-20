#!/usr/bin/python3
import requests
import json
import sys
import platform
from datetime import datetime

####                                                                          ####
#                                                                                #
#  Volle Dokumentation: https://github.com/marekbeckmann/icinga-check-linux-eol  #
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
def check(hostOS, hostOSVers):
    os_data = requests.get(
        "https://endoflife.date/api/" + hostOS + ".json").text
    os_data = json.loads(os_data)
    for el in os_data:
        try:
            if hostOSVers == el["latest"]:
                present = datetime.now().date()
                eoldate = datetime.strptime(el["eol"], "%Y-%m-%d").date()
                if eoldate > present:
                    status = OK
                    message['summary'] = 'EOL: ' + el["eol"]
                    break
                else:
                    status = CRITICAL
                    message['summary'] = 'EOL: ' + eoldate
                    break
            else:
                status = UNKNOWN
                message['summary'] = 'OS Version not in Database'
        except:
            pass
    return status


hostOs = "debian"
hostOSVers = "10.11"


# Output to Icinga
message['status'] = check(hostOs, hostOSVers)
print("{summary}".format(
    summary=message.get('summary'),
))
raise SystemExit(message['status'])