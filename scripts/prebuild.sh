#!/bin/bash

set -oue pipefail

RELEASE="$(rpm -E %fedora)"

# Colours
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[1;31m"
NC="\033[0m" # No Colour

echo -en ${RED}
cat << 'EOF'
 ____          _  ___                                        _   
|  _ \ ___  __| |/ _ \ _   _  __ _ ___  __ _ _ __ _ __   ___| |_ 
| |_) / _ \/ _` | | | | | | |/ _` / __|/ _` | '__| '_ \ / _ \ __|
|  _ <  __/ (_| | |_| | |_| | (_| \__ \ (_| | |_ | | | |  __/ |_ 
|_| \_\___|\__,_|\__\_\\__,_|\__,_|___/\__,_|_(_)|_| |_|\___|\__|
EOF
echo -e ${NC}

echo -e "${CYAN}Now building ${GREEN}redqausar-ublue.${NC}"
echo -e "${CYAN}Visit ${GREEN}https://github.com/ahallrq/redquasar-ublue${CYAN} for usage and license information.${NC}"
echo ""