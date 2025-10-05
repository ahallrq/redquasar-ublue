#!/bin/bash

set -ouex pipefail

# Colours
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
RED="\033[1;31m"
NC="\033[0m" # No Colour

/ctx/banner.sh

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Enable the hyprland COPR because Fedora's repos kinda suck
dnf5 -y copr enable solopasha/hyprland

# Install critical system libraries and tools
echo -e "${CYAN}Installing system libraries and tools...${NC}"
dnf5 -y install \
    distrobox \
    podman \
    virt-install libvirt qemu-kvm libvirt-daemon-kvm \
    virt-manager edk2-ovmf swtpm\

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
    mate-polkit network-manager-applet \
    qt5-qtwayland qt6-qtwayland \
    sddm xorg-x11-server-Xwayland \
    gnome-keyring \
    mesa-dri-drivers mesa-vulkan-drivers vulkan-loader \
    virglrenderer
      
#dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging\
dnf5 -y copr disable solopasha/hyprland

#### Example for enabling a System Unit File

echo -e "${CYAN}Enabling system services...${NC}"
systemctl enable NetworkManager
systemctl enable podman.socket
systemctl enable sddm
systemctl enable tailscaled

# Fix missing users
install -d /usr/lib/sysusers.d

cat > /usr/lib/sysusers.d/90-sddm.conf <<'SYS'
# type name  id  gecos                               home
g sddm
u sddm -  "Simple Desktop Display Manager"           /var/lib/sddm
m sddm sddm
SYS

cat > /usr/lib/sysusers.d/90-libvirt.conf <<'SYS'
# groups
g libvirt
g kvm
# qemu runtime user (Fedora runs QEMU as an unprivileged user)
u qemu - "QEMU virtual machine user" /var/lib/libvirt
# make sure qemu is in kvm and libvirt groups
m qemu kvm
m qemu libvirt
SYS

# Fix libvirt
install -d /usr/lib/tmpfiles.d
cat > /usr/lib/tmpfiles.d/90-libvirt.conf <<'TMP'
# path                         mode  user group  age  arg
d /var/lib/libvirt             0755  root root   -
d /var/lib/libvirt/images      0755  root root   -
d /var/cache/libvirt           0755  root root   -
d /var/log/libvirt             0755  root root   -
TMP

# Set up SDDM config
install -d /etc/sddm.conf.d
cat > /etc/sddm.conf.d/10-wayland.conf <<'CFG'
[General]
# optional: pick a theme that exists; comment out if unsure
# Theme=Maldives

[Wayland]
# SDDM’s own greeter runs as a client; make sure qt*-qtwayland is installed
CompositorCommand=
# Helpful for some setups:
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell
SessionCommand=/usr/bin/wayland-session
CFG

systemctl set-default graphical.target
systemd-sysusers