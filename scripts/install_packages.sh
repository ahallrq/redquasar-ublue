#!/bin/bash

set -oue pipefail

RELEASE="$(rpm -E %fedora)"

# Path to your packages.json file
PACKAGE_JSON="/tmp/buildtmp/packages.json"

# # Directory containing the .txt files
# PACKAGE_DIR="/tmp/packages/"

# Colours
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No Colour

echo -e "${CYAN}Preparing to install repos and packages...${NC}"

# Function to add repositories
add_repositories() {
    # echo -e "${CYAN}Processing repositories section${NC}"

    # Read the repositories in the repos section
    REPOS=$(jq -r ".repos[]" "$PACKAGE_JSON")

    # Loop through each repository and add it by curling the .repo file to yum.repos.d
    for REPO in $REPOS; do
        REPO_NAME=$(basename "$REPO")
        echo -e "${CYAN}Adding repository: ${YELLOW}$REPO${NC}"
        sudo curl -so "/etc/yum.repos.d/$REPO_NAME" "$REPO"
    done
}

# Function to install packages from a section
install_packages() {
    GROUP_NAME="$1"
    # echo -e "${CYAN}Processing package group: ${YELLOW}$GROUP_NAME${NC}"
    
    # Read the packages in the section
    PACKAGES=$(jq -r ".${GROUP_NAME}[]" "$PACKAGE_JSON")
    
    # Join all packages into a single command
    PACKAGE_LIST=$(echo "$PACKAGES" | tr '\n' ' ')

    if [ -n "$PACKAGE_LIST" ]; then
        echo -e "${CYAN}Installing packages in \"${YELLOW}$GROUP_NAME${CYAN}\" group: ${YELLOW}$PACKAGE_LIST${NC}"
        SYSTEMD_LOG_LEVEL=err rpm-ostree install -qy $PACKAGE_LIST >> /tmp/build-rpm-ostree.log
    # else
    #     echo "No packages to install in section: $GROUP_NAME"
    fi
}

# Check if the repos section exists and process it first
if jq -e '.repos' "$PACKAGE_JSON" > /dev/null; then
    add_repositories
# else
#     echo "No repositories section found."
fi

# Get all the sections in the JSON file, excluding "repos"
SECTIONS=$(jq -r 'keys[] | select(. != "repos")' "$PACKAGE_JSON")

# Loop through each section and install the packages
for SECTION in $SECTIONS; do
    install_packages "$SECTION"
done

echo -e "${CYAN}Finished installing repos and packages...${NC}"


# # Loop through each .txt file in the directory
# for file in "$PACKAGE_DIR"*.txt; do
#     if [[ -f "$file" ]]; then
#         echo -e "${CYAN}Installing packages from file: ${YELLOW}$file${NC}"
        
#         # Install packages listed in the file
#         rpm-ostree -q install -qy $(cat "$file") >> /tmp/build-rpm-ostree.log
        
#         if [[ $? -eq 0 ]]; then
#             echo -e "${GREEN}Finished installing packages from file: ${YELLOW}$file${NC}"
#         else
#             echo -e "${RED}Failed to install packages from file: ${YELLOW}$file${NC}"
#         fi
#     else
#         echo -e "${RED}No package lists found in ${YELLOW}$PACKAGE_DIR${NC}"
#     fi
# done

# # Tailscale requires a repo and this script doesn't handle this as of yet so we'll do it manually for now.
# echo -e "${CYAN}Installing Tailscale from the official Tailscale repo.${NC}"
# curl -s -L -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
# rpm-ostree install -q tailscale >> /tmp/build-rpm-ostree.log