#!/bin/bash

set -ouex pipefail

# Colours
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[1;31m"
NC="\033[0m" # No Colour

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos

# Install critical system libraries and tools
#echo -e "${CYAN}Installing system libraries and tools...${NC}"

# Add repositories for additional packages
echo -e "${CYAN}Adding additional package repositories...${NC}"
dnf5 config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo

# Install NetworkManager and related packages
echo -e "${CYAN}Installing network management packages...${NC}"
dnf5 -y install \
    NetworkManager NetworkManager-wifi \
    NetworkManager-tui NetworkManager-bluetooth \
    bluez bluez-tools \
    rfkill \
    iw wpa_supplicant \
    tailscale
    
# Install Hyprland and related packages
echo -e "${CYAN}Installing display manager and desktop environment packages...${NC}"
dnf5 -y install \
    hyprland \
    hypridle hyprlock \
    xdg-desktop-portal-hyprland \
    waybar wofi wlogout \
    wl-clipboard cliphist \
    grim slurp swappy \
    brightnessctl playerctl \
    pavucontrol alsa-utils \
    polkit-gnome network-manager-applet \
    qt5-qtwayland qt6-qtwayland \
    sddm sddm-wayland-generic xorg-xwayland \
    gnome-keyring
      
#dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

echo -e "${CYAN}Enabling system services...${NC}"
systemctl enable NetworkManager
systemctl enable podman.socket
systemctl enable sddm
systemctl enable tailscaled
