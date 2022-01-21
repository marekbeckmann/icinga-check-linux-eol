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

You can pass the following options: 

| Option                    | Description                                   |
| ------------------------- | --------------------------------------------- |
| --distro `<distribution>` | Specify the Distribution, e.g `debian`        |
| --version `<version>`     | Specify the OS Version, e.g `11.2`            |
| --name `<pretty name>`    | Specify the Pretty Name of the distribution   |
| --homepage `<URL>`        | Specify the Homepage URL of your distribution |

To programatically find these needed values, you can use the following commands (might differ depending on your distribution): 

For the OS: 
```bash
. /etc/os-release
echo ${ID_LIKE}
```
For the Version: 
```bash
cat /etc/debian_release
```

## 3. Running without parameters

You can run the script without parameters, using the provided Bash-Script, that does it for you. The Script will extract all needed information from your system and pass it to the Pyton Check-Script. You will have to specify the Bash-Script as Plugin, not the Python script.