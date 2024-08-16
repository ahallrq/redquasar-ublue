#!/bin/bash

# From: https://github.com/noelmiller/isengard/blob/main/scripts/just.sh

set -oue pipefail

# Colours
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No Colour

echo -e "${GREEN}Importing Justfiles...${NC}"
echo "import \"/usr/share/ublue-os/just/99-redquasar.just\"" >> /usr/share/ublue-os/justfile