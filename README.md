# Raspberry Pi configs

Simply download any of the files on pc or with `sudo wget` in the terminal.

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
