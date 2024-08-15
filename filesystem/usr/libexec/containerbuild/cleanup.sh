#!/usr/bin/bash

# From: https://github.com/ublue-os/bazzite/blob/main/system_files/desktop/shared/usr/libexec/containerbuild/cleanup.sh

set -eoux pipefail
shopt -s extglob

rm -rf /tmp/* || true
rm -rf /var/!(cache)
rm -rf /var/cache/!(rpm-ostree)