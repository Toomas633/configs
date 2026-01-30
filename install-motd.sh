#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "apt-get not found; this script requires Ubuntu." >&2
  exit 1
fi

if [ -r /etc/os-release ]; then
  . /etc/os-release
  if [ "${ID:-}" != "ubuntu" ] && [[ "${ID_LIKE:-}" != *ubuntu* ]]; then
    echo "This script requires Ubuntu." >&2
    exit 1
  fi
else
  echo "Unable to detect OS; this script requires Ubuntu." >&2
  exit 1
fi

if [ -e /etc/update-motd ]; then
  if [ -L /etc/update-motd ] || [ -f /etc/update-motd ]; then
    rm -f /etc/update-motd
  elif [ -d /etc/update-motd ]; then
    rm -rf /etc/update-motd
  fi
fi
mkdir -p /etc/update-motd.d
echo "Clearing /etc/update-motd.d (existing scripts will be removed)..."
find /etc/update-motd.d -mindepth 1 -delete

echo "Installing MOTD dependencies..."
export DEBIAN_FRONTEND=noninteractive
if ! apt-get update; then
  echo "apt-get update failed." >&2
  exit 1
fi
if ! apt-get install -y \
  docker.io \
  lsb-release \
  ubuntu-release-upgrader-core \
  unattended-upgrades \
  ubuntu-advantage-tools \
  update-notifier \
  util-linux \
  procps \
  curl; then
  echo "apt-get install failed." >&2
  exit 1
fi

echo "Downloading MOTD scripts..."
BASE_URL="https://raw.githubusercontent.com/Toomas633/configs/HEAD/motd"
SCRIPTS=(
  10-sysinfo
  20-diskspace
  30-services
  50-docker
  60-pemmican
  90-updates-available
  91-release-upgrade
  92-unattended-upgrades
  93-contract-ua-esm-status
  95-hwe-eol
  97-overlayroot
  98-reboot-required
  99-fsck-at-reboot
)

for script in "${SCRIPTS[@]}"; do
  if ! curl -fsSL "${BASE_URL}/${script}" -o "/etc/update-motd.d/${script}"; then
    echo "Failed to download ${script}." >&2
    exit 1
  fi
  if [ ! -s "/etc/update-motd.d/${script}" ]; then
    echo "Downloaded ${script} is empty." >&2
    exit 1
  fi
  chmod +x "/etc/update-motd.d/${script}"
done

echo "MOTD scripts installed."
