#!/bin/bash

set -oue pipefail
set +x

RELEASE="$(rpm -E %fedora)"

cat << 'EOF'
  ____          _  ___                                        _   
 |  _ \ ___  __| |/ _ \ _   _  __ _ ___  __ _ _ __ _ __   ___| |_ 
 | |_) / _ \/ _` | | | | | | |/ _` / __|/ _` | '__| '_ \ / _ \ __|
 |  _ <  __/ (_| | |_| | |_| | (_| \__ \ (_| | |_ | | | |  __/ |_ 
 |_| \_\___|\__,_|\__\_\\__,_|\__,_|___/\__,_|_(_)|_| |_|\___|\__|
                                                                  
EOF

echo "Now building redqausar-ublue."
echo "Visit https://github.com/rdqsrau/redquasar-ublue for usage and license information."
echo ""