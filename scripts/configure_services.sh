#!/bin/bash

set -oue pipefail

RELEASE="$(rpm -E %fedora)"

# Path to your services.json file
SERVICE_JSON="/tmp/buildtmp/services.json"

# Colours
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No Colour

echo -e "${CYAN}Preparing to configure services...${NC}"

# Function to add repositories
configure_services() {
    ACTION=$1 # Should be enable, disable, mask, unmask
    ACTION_VERB=$2

    SERVICES=$(jq -r ".$ACTION[]" "$SERVICE_JSON")

    for SERVICE in $SERVICES; do
        if [[ "$SERVICE" == *.* ]]; then # Nice handling for displaying "service", "timer", "socket" etc.
            SERVICE_TYPE="${SERVICE##*.}"
        else
            SERVICE_TYPE="service" # Fallback to a simple "service" if the type is omitted.
        fi
        echo -e "${CYAN}$ACTION_VERB $SERVICE_TYPE: ${YELLOW}$SERVICE${NC}"
        systemctl -q $ACTION $SERVICE
    done
}

if jq -e '.enable' "$SERVICE_JSON" > /dev/null; then
    configure_services "enable" "Enabling"
fi


if jq -e '.disable' "$SERVICE_JSON" > /dev/null; then
    configure_services "disable" "Disabling"
fi


if jq -e '.mask' "$SERVICE_JSON" > /dev/null; then
    configure_services "mask" "Masking"
fi


if jq -e '.unmask' "$SERVICE_JSON" > /dev/null; then
    configure_services "unmask" "Unmasking"
fi

echo -e "${CYAN}Finished configuring services...${NC}"