#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Development Tools
#rpm-ostree install cmake cmake-gui autoconf automake binutils bison flex gcc gcc-c++ gdb glibc-devel libtool make pkgconf strace byacc ccache cscope ctags elfutils indent ltrace perf valgrind

# Xorg (no soyland here thanks)
rpm-ostree install \
    xorg-x11-server-Xorg \
    xorg-x11-xinit \
    xorg-x11-drivers \
    xorg-x11-xauth \
    mesa-dri-drivers \
    mesa-vulkan-drivers \
    mesa-libGL \
    mesa-libEGL \
    mesa-libGLU \
    glx-utils \
    xrandr \
    xsetroot \
    xclip \
    xterm

# Multimedia
rpm-ostree install pipewire-pulseaudio pipewire-utils wireplumber

# Editing Tools
rpm-ostree install neovim

# System Tools
rpm-ostree install zsh btop iftop iotop tmux inxi

# Tailscale
curl -L -o /etc/yum.repos.d/tailscale.repo https://pkgs.tailscale.com/stable/fedora/tailscale.repo
rpm-ostree install tailscale

# Display Manager
rpm-ostree install sddm sddm-themes sddm-x11

# Desktop
rpm-ostree install i3 i3-doc i3-config i3-devel polybar jsoncpp-devel xcb-util-xrm-devel xcb-util-cursor-devel libnl3-devel

# this would install a package from rpmfusion
# rpm-ostree install vlc

