# Configs

- [Configs](#configs)
  * [Wifi config:](#wifi-config)
  * [Overclocking Pi 4:](#overclocking-pi-4)
  * [Overclocking Pi Zero:](#overclocking-pi-zero)
  * [Command aliases:](#command-aliases)
  * [MOTD installer:](#motd-installer)

## Wifi config:
Copy the wpa_supplicant.conf file to your sd boot partition (should have files like bootcode.bin, loader.bin, start.elf, kernel.img, cmdline.txt) on pc or copy contents to `/etc/wpa_supplicant/wpa_supplicant.conf`

## Overclocking Pi 4:
Copy the contents of Pi4_config.txt contents to `/boot/config.txt`

## Overclocking Pi Zero:
Copy the contents of Zero_config.txt contents to `/boot/config.txt`

## Command aliases:
Included are some common aliases to make life and navigating the command line easyer. Simply copy/download the file .bash_aliases to your home folder.
* Navigate to the home folder `cd ~`
* Download the file with `sudo wget https://raw.githubusercontent.com/Toomas633/raspberry-pi-configs/main/.bash_aliases`
* Reboot or relog

## MOTD installer:
Download and run the installer with wget: `wget -qO install-motd.sh https://raw.githubusercontent.com/Toomas633/configs/HEAD/install-motd.sh && sudo bash install-motd.sh` to install/update the MOTD scripts under `/etc/update-motd.d` (requires sudo and apt-get on a Debian-based system; installs dependencies like lsb-release, unattended-upgrades, util-linux, procps, wget, plus Ubuntu-only packages such as ubuntu-release-upgrader-core, ubuntu-advantage-tools, and update-notifier when on Ubuntu; scripts for docker/systemd/Ubuntu are installed conditionally).
Alternatively, pipe it directly to bash: `wget -qO- https://raw.githubusercontent.com/Toomas633/configs/HEAD/install-motd.sh | sudo bash` (consider downloading and reviewing the script before piping).
The installer uses dpkg-divert to locally divert default update-motd scripts so package upgrades do not restore them.

## Donate:
[toomas633.com/donate](https://toomas633.com/donate/)
