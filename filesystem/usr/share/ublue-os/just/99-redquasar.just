
# Install Recommended System Flatpaks
install-system-flatpaks:
    #!/bin/bash
    source /usr/lib/ujust/ujust.sh
    SYSTEM_FLATPAK_LIST="$(curl https://raw.githubusercontent.com/ahallrq/redquasar-ublue/main/flatpaks/system_flatpaks | tr '\n' ' ')"
    echo "Installing System Flatpaks.."
    flatpak --system -y install ${SYSTEM_FLATPAK_LIST}