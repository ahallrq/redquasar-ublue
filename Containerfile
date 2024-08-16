ARG SOURCE_IMAGE="base"
ARG SOURCE_SUFFIX="-main"
ARG SOURCE_TAG="40"

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
