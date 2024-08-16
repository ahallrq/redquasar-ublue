#!/bin/bash

set -oue pipefail

RELEASE="$(rpm -E %fedora)"

# Directory containing the .txt files
PACKAGE_DIR="/tmp/packages/"

# Colours
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No Colour

echo -e "${CYAN}Preparing to install packages...${NC}"

# Loop through each .txt file in the directory
for file in "$PACKAGE_DIR"*.txt; do
    if [[ -f "$file" ]]; then
        echo -e "${CYAN}Installing packages from file: ${YELLOW}$file${NC}"
        
        # Install packages listed in the file
        rpm-ostree -q install -qy $(cat "$file") >> /tmp/build-rpm-ostree.log
        
        if [[ $? -eq 0 ]]; then
            echo -e "${GREEN}Finished installing packages from file: ${YELLOW}$file${NC}"
        else
            echo -e "${RED}Failed to install packages from file: ${YELLOW}$file${NC}"
        fi
    else
        echo -e "${RED}No package lists found in ${YELLOW}$PACKAGE_DIR${NC}"
    fi
done

# Tailscale requires a repo and this script doesn't handle this as of yet so we'll do it manually for now.
echo -e "${CYAN}Installing Tailscale from the official Tailscale repo.${NC}"
curl -s -L -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
rpm-ostree install -q tailscale >> /tmp/build-rpm-ostree.log