#!/usr/bin/bash

# From: https://github.com/ublue-os/bazzite/blob/main/system_files/desktop/shared/usr/libexec/containerbuild/cleanup.sh

set -eou pipefail
shopt -s extglob

# Colours
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No Colour

echo -e "${CYAN}Performing cleanup operations on container.${NC}"
rm -rf /tmp/* || true
rm -rf /var/!(cache)
rm -rf /var/cache/!(rpm-ostree)