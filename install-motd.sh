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

is_ubuntu=false
if [ -r /etc/os-release ]; then
  . /etc/os-release
  if [ "${ID:-}" = "ubuntu" ] || [[ "${ID_LIKE:-}" == *ubuntu* ]]; then
    is_ubuntu=true
  fi
else
  echo "Unable to detect OS; this script requires Ubuntu." >&2
  exit 1
fi

if [ "$is_ubuntu" != true ]; then
  echo "This script requires Ubuntu." >&2
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

echo "Installing MOTD dependencies..."
export DEBIAN_FRONTEND=noninteractive
if ! apt-get update; then
  echo "apt-get update failed." >&2
  exit 1
fi
if ! apt-get install -y \
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
)

has_systemd=false
if command -v systemctl >/dev/null 2>&1 && [ "$(cat /proc/1/comm 2>/dev/null)" = "systemd" ]; then
  has_systemd=true
fi

has_docker=false
if command -v docker >/dev/null 2>&1; then
  has_docker=true
fi

if [ "$has_systemd" = true ]; then
  SCRIPTS+=(30-services)
fi

if [ "$has_docker" = true ]; then
  SCRIPTS+=(50-docker)
fi

SCRIPTS+=(
  60-pemmican
  90-updates-available
  91-release-upgrade
  92-unattended-upgrades
)

# Explicit Ubuntu gating for the UA ESM status script.
if [ "$is_ubuntu" = true ]; then
  SCRIPTS+=(93-contract-ua-esm-status)
fi

SCRIPTS+=(
  95-hwe-eol
  97-overlayroot
  98-reboot-required
  99-fsck-at-reboot
)

if command -v dpkg-divert >/dev/null 2>&1; then
  add_diversion() {
    local path="$1"
    local rename_existing="${2:-false}"
    local rename_flag="--no-rename"
    if dpkg-divert --list "$path" 2>/dev/null | grep -qF "diversion of ${path} to"; then
      return 0
    fi
    if [ "$rename_existing" = true ] && [ -e "$path" ]; then
      rename_flag="--rename"
    fi
    if ! dpkg-divert --local "$rename_flag" --divert "${path}.disabled" --add "$path"; then
      echo "Failed to divert ${path}." >&2
      exit 1
    fi
  }

  declare -A diverted_paths=()
  while IFS= read -r -d '' script; do
    add_diversion "$script" true
    diverted_paths["$script"]=1
  done < <(find /etc/update-motd.d -mindepth 1 -maxdepth 1 \( -type f -o -type l \) -print0)

  # Preemptively divert installer-managed scripts so package upgrades cannot restore them.
  for script in "${SCRIPTS[@]}"; do
    script_path="/etc/update-motd.d/${script}"
    if [ -n "${diverted_paths[$script_path]:-}" ]; then
      continue
    fi
    add_diversion "$script_path" false
  done
fi

echo "Clearing /etc/update-motd.d (existing scripts will be removed)..."
# Preserve dpkg-divert renamed files.
find /etc/update-motd.d -mindepth 1 ! -name '*.disabled' -delete

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
