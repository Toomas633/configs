# Configs

- [Configs](#configs)
  * [Wifi config:](#wifi-config)
  * [Overclocking Pi 4:](#overclocking-pi-4)
  * [Overclocking Pi Zero:](#overclocking-pi-zero)
  * [Command aliases:](#command-aliases)
  * [Xmrig install script:](#xmrig-install-script)
    + [To install:](#to-install)


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

## Xmrig install script:
Automatic cloning, building and configuring of xmrig for PiOSx64 or Ubuntu (server).
* Asks for your wallet address and mingin pool url with port *(for example gulf.moneroocean.com:10128)* and device/miner name.
* Creates a specific *"miner"* user so your home folder won't be cluttered.
* Autoconfigures for startup and control as service *(xmrig.service)*.
### How to install:
* Download the file with `sudo wget https://raw.githubusercontent.com/Toomas633/configs/main/installers/xmrig.sh`
* Allow running with `sudo chmod a+x xmrig.sh`
* Run `sudo ./xmrig.sh`, fill in the 3 questions, and wait.
### Optional:
Add `"rx/0": [-1, -1, -1],` to `/home/miner/xmrig/build/config.json` under cpu: configuration to control cpu usage (each -1 represents a thread).
Donate Monero `46b9jWCbtfDEGibADKG5uqL12r8RDohm1ZjkSK2ZW3T3gTsUYSPGpvu5fvhJZjuBGRbN8HnKWc8T6RFvzuUxTQjFF5osdeP`.
