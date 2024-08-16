#!/bin/bash

set -oue pipefail

RELEASE="$(rpm -E %fedora)"

# Path to your packages.json file
PACKAGE_JSON="/tmp/buildtmp/packages.json"

# Colours
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No Colour

echo -e "${CYAN}Preparing to install repos and packages...${NC}"

# Function to add repositories
add_repositories() {
    # Read the repositories in the repos section
    REPOS=$(jq -r ".repos[]" "$PACKAGE_JSON")

    # Loop through each repository and add it by curling the .repo file to /etc/yum.repos.d/
    for REPO in $REPOS; do
        REPO_NAME=$(basename "$REPO")
        echo -e "${CYAN}Adding repository: ${YELLOW}$REPO${NC}"
        sudo curl -so "/etc/yum.repos.d/$REPO_NAME" "$REPO"
    done
}

# Function to install packages from a group
install_packages() {
    GROUP_NAME="$1"
    
    # Read the packages in the group
    PACKAGES=$(jq -r ".${GROUP_NAME}[]" "$PACKAGE_JSON")
    
    # Join all packages into a single command
    PACKAGE_LIST=$(echo "$PACKAGES" | tr '\n' ' ')

    if [ -n "$PACKAGE_LIST" ]; then
        echo -e "${CYAN}Installing packages in \"${YELLOW}$GROUP_NAME${CYAN}\" group: ${YELLOW}$PACKAGE_LIST${NC}"
        SYSTEMD_LOG_LEVEL=err rpm-ostree install -qy $PACKAGE_LIST >> /tmp/build-rpm-ostree.log
    fi
}

# Check if the repos array exists and process it first
if jq -e '.repos' "$PACKAGE_JSON" > /dev/null; then
    add_repositories
fi

# Get all the package groups in the JSON file, excluding "repos"
PKGGROUPS=$(jq -r 'keys[] | select(. != "repos")' "$PACKAGE_JSON")

# Loop through each section and install the packages
for PKGGROUP in $PKGGROUPS; do
    install_packages "$PKGGROUP"
done

echo -e "${CYAN}Finished installing repos and packages...${NC}"