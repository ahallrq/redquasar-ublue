## 1. BUILD ARGS
# These allow changing the produced image by passing different build args to adjust
# the source from which your image is built.
# Build args can be provided on the commandline when building locally with:
#   podman build -f Containerfile --build-arg FEDORA_VERSION=40 -t local-image

# SOURCE_IMAGE arg can be anything from ublue upstream which matches your desired version:
# See list here: https://github.com/orgs/ublue-os/packages?repo_name=main
# - "silverblue"
# - "kinoite"
# - "sericea"
# - "onyx"
# - "lazurite"
# - "vauxite"
# - "base"
#
#  "aurora", "bazzite", "bluefin" or "ucore" may also be used but have different suffixes.
ARG SOURCE_IMAGE="base"

## SOURCE_SUFFIX arg should include a hyphen and the appropriate suffix name
# These examples all work for silverblue/kinoite/sericea/onyx/lazurite/vauxite/base
# - "-main"
# - "-nvidia"
# - "-asus"
# - "-asus-nvidia"
# - "-surface"
# - "-surface-nvidia"
#
# aurora, bazzite and bluefin each have unique suffixes. Please check the specific image.
# ucore has the following possible suffixes
# - stable
# - stable-nvidia
# - stable-zfs
# - stable-nvidia-zfs
# - (and the above with testing rather than stable)
ARG SOURCE_SUFFIX="-main"

## SOURCE_TAG arg must be a version built for the specific image: eg, 39, 40, gts, latest
ARG SOURCE_TAG="40"

### 2. SOURCE IMAGE
## this is a standard Containerfile FROM using the build ARGs above to select the right upstream image
FROM ghcr.io/ublue-os/${SOURCE_IMAGE}${SOURCE_SUFFIX}:${SOURCE_TAG}

COPY filesystem /
COPY ["scripts","data", "/tmp/buildtmp/"]

# Display a nice banner telling the user about this build.
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    /tmp/buildtmp/prebuild.sh

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    echo -e "\033[1;32m==[ Package Installation ]==\033[0m" && \
    mkdir -p /var/lib/alternatives && \
    /tmp/buildtmp/install_packages.sh

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    echo -e "\033[1;32m==[ Services ]==\033[0m" && \
    /tmp/buildtmp/configure_services.sh

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    echo -e "\033[1;32m==[ Justfiles ]==\033[0m" && \
    /tmp/buildtmp/just.sh

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    echo -e "\033[1;32m==[ Initramfs ]==\033[0m" && \  
    /usr/libexec/containerbuild/build-initramfs

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    echo -e "\033[1;32m==[ Cleanup ]==\033[0m" && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit

## NOTES:
# - /var/lib/alternatives is required to prevent failure with some RPM installs
# - All RUN commands must end with ostree container commit
#   see: https://coreos.github.io/rpm-ostree/container/#using-ostree-container-commit
