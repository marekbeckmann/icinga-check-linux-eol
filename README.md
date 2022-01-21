# Icinga Check for Linux EOL

## 1. What does the Plugin do?

The Plugin will query the [endoflife.date](https://endoflife.date) API and check if your running Linux System is out of date. As of now, the major Linux distributions the API supports are: 

- Debian
- Ubuntu
- Centos
- RHEL
- Rocky Linux
- OpenSUSE

## 2. How to run?

### 2.1 Requirements

- Python 3.6 or higher
- Python `requests` module

To install the requests module, make sure you have `python3-pip` installed on your system. Then simply run

```
pip3 -q install requests
```

### 2.2 Running directly

You can pass the following options to `check-eol.py`: 

| Option                    | Description                                   | Required |
| ------------------------- | --------------------------------------------- | -------- |
| --distro `<distribution>` | Specify the Distribution, e.g `debian`        | [x]      |
| --version `<version>`     | Specify the OS Version, e.g `11.2`            | [x]      |
| --name `<pretty name>`    | Specify the Pretty Name of the distribution   | [ ]      |
| --homepage `<URL>`        | Specify the Homepage URL of your distribution | [ ]      |

E.g: 
```
python3 check-eol.py --distro debian --version 11.3
```

It is recommended, to programatically determine the needed variables (e.g using Bash), especially the version information. Here are some pointers on how to determine version information for most linux distributions: 

For the OS: 
```bash
. /etc/os-release
echo "Distribution: ${ID}"
echo "Version: ${VERSION_ID}"
```

### 2.3 Running trough Bash-Script

If you don't want to worry about finding out the needed info, you can specify the `check-eol.sh` in your Icinga/Nagios check command. The script will then call the Python Check-Plugin with all parameters. It uses the following commands to determine the information needed: 

- `--distro` => `${ID}` 
- `--version` => `${VERSION_ID}` (`/etc/debian_version` for Debian)
- `--name` => `${PRETTY_NAME}` 
- `--homepage` => `${HOME_URL}`