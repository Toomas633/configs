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
Clone this repository and run `sudo bash install-motd.sh` to install/update the MOTD scripts under `/etc/update-motd.d` (requires sudo and installs dependencies like lsb-release, ubuntu-release-upgrader-core, unattended-upgrades, ubuntu-advantage-tools, update-notifier, util-linux, procps, curl; scripts for docker/systemd/Ubuntu are installed conditionally). The installer uses dpkg-divert to locally divert default update-motd scripts so package upgrades do not restore them.

## Donate:
[toomas633.com/donate](https://toomas633.com/donate/)
