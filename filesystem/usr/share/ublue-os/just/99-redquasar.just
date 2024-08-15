
# Install Recommended System Flatpaks
install-system-flatpaks:
    #!/bin/bash
    source /usr/lib/ujust/ujust.sh
    echo "Warning: This will remove ${bold}${red}ALL${normal} installed system flatpaks and replace them with ones recommended by this build."
    echo "Are you sure you want to continue?"
    read -p "Continue (y/n)? " choice
    case "$choice" in
    y|Y ) ;;
    n|N ) exit;;
    * ) exit;;
    esac
    echo "Cleaning up system flatpaks.."
    for app in $(flatpak list --system --columns=application,origin | grep fedora | awk '{print $1}'); do
        flatpak uninstall -y $app
    done
    flatpak remote-delete fedora --force 2>/dev/null
    echo "Installing recommended system flatpaks.."
    SYSTEM_FLATPAK_LIST="$(curl https://raw.githubusercontent.com/ahallrq/redquasar-ublue/main/flatpaks/system_flatpaks | tr '\n' ' ')"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak --system -y install ${SYSTEM_FLATPAK_LIST}