#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

#### Example for enabling a System Unit File
systemctl enable podman.socket