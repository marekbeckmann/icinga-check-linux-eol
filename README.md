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

| Option                      | Description                                   | Required |
| --------------------------- | --------------------------------------------- | -------- |
| `--distro` `<distribution>` | Specify the distribution, e.g `debian`        | ✅        |
| `--version` `<version>`     | Specify the OS version, e.g `11.2`            | ✅        |
| `--name` `<pretty name>`    | Specify the "Pretty Name" of the distribution | ❌        |
| `--homepage` `<URL>`        | Specify the Homepage URL of your distribution | ❌        |
| `-h` `--help`               | Print a help message                          | ❌        |

E.g: 
```
python3 check-eol.py --distro debian --version 11.3
```

It is recommended, to programatically determine the needed arguments (e.g using Bash), especially the version information. Here are some pointers on how to determine the version information on most linux distributions: 

```bash
. /etc/os-release
echo "Distribution: ${ID}"
echo "Version: ${VERSION_ID}"
```

### 2.3 Running trough Bash-Script

If you don't want to worry about finding out the needed information yourself, you can specify the `check-eol.sh` in your Icinga/Nagios check command. The script will then call the Python Check-Plugin with all parameters. It uses the following commands to determine the information needed: 

- `--distro` => `${ID}` 
- `--version` => `${VERSION_ID}` (`/etc/debian_version` for Debian)
- `--name` => `${PRETTY_NAME}` 
- `--homepage` => `${HOME_URL}`

E.g for a quick test-run, you can use the following: 
```bash
git clone https://github.com/marekbeckmann/icinga-check-linux-eol.git && \
bash icinga-check-linux-eol/check-eol.sh
```
You can use the following options running the script: 

| Option                     | Description                                             | Required |
| -------------------------- | ------------------------------------------------------- | -------- |
| `-d` `--dir` `<directory>` | Specify the working directory, e.g `/opt/nagiosplugins` | ❌        |
| `-h` `--help`              | Print a help message                                    | ❌        |


## 3. Icinga Check Command

The following are two examples for a check command in your `commands.conf`.

Using the Bash script: 
```php
object CheckCommand "check-eol" {
  command = [ PluginDir + "/check-eol.sh" ]
}
```

Using the Python script: 
```php
object CheckCommand "check-eol" {
  command = [ PluginDir + "/check-eol.py" ]
  arguments += {
      "--distro" = "debian"
      "--version" = "11.2"
  }
}
```

Make sure, that you have also configured a correspondig service in your `services.conf`

E.g: 
```php
apply Service "eolcheck" {
  import "generic-service"
  check_command = "check-eol"
  assign where host.vars.os == "Linux"
}
```
## 4. Current State
As of now, this script has been tested with the following distributions: 

| Distribution       | Supported by API | Works properly |
| ------------------ | ---------------- | -------------- |
| Debian Bullseye    | ✅                | ✅              |
| Debian Buster      | ✅                | ✅              |
| Centos 7           | ✅                | ✅              |
| Alma Linux         | ❌                | ✅              |
| OpenSUSE Leap 15.3 | ✅                | ✅              |
| Ubuntu 20.04 LTS   | ✅                | ✅              |
