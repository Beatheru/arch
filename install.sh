#!/bin/bash
#
# Usage: ./install.sh [niri] [umbriel]
# With no arguments both compositors are installed.

set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "Do not run this script as root or with sudo."
  exit 1
fi

export INSTALL_HOME="$(cd "$(dirname "$0")" && pwd)"
source "$INSTALL_HOME/lib/all.sh"

# Supported compositors, and the default when none are given
available=(niri umbriel)

compositors=("$@")
((${#compositors[@]})) || compositors=("${available[@]}")
for c in "${compositors[@]}"; do
  [[ " ${available[*]} " == *" $c "* ]] || { log ERROR "Unknown compositor: $c (choose from: ${available[*]})"; exit 1; }
done

# Ask for the password once and keep sudo's login fresh until the installer exits
sudo -v
while sleep 60; do sudo -n -v; done &
trap 'kill $!' EXIT

start=$(date +%s)

run_script "$INSTALL_HOME/preflight/prepare.sh"
run_script "$INSTALL_HOME/preflight/packages.sh" "${compositors[@]}"

source "$INSTALL_HOME/base/all.sh"
for c in "${compositors[@]}"; do
  source "$INSTALL_HOME/$c/all.sh"
done

end=$(date +%s)
elapsed=$((end - start))

log SUCCESS "Finished in $((elapsed / 60))m $((elapsed % 60))s"
