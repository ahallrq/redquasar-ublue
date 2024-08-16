#!/bin/bash

set -oue pipefail

RELEASE="$(rpm -E %fedora)"

systemctl enable podman.socket
systemctl enable tailscaled