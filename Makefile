# Makefile for building and pushing the redquasar-ublue image

# Variables
IMAGE_NAME=redquasar-ublue
TAG=latest
LOCAL_REGISTRY=localhost
REMOTE_REGISTRY=10.50.0.218:5000

.PHONY: all build push

# Default target
all: build push

# Build the image
build:
	podman build . -t $(IMAGE_NAME)

# Push the image to the remote registry
push:
	podman push --quiet $(LOCAL_REGISTRY)/$(IMAGE_NAME):$(TAG) $(REMOTE_REGISTRY)/$(IMAGE_NAME):$(TAG)

# Generate ISO file
geniso:
	mkdir -p ./build
	-rm ./build/*
	sudo podman run --rm --privileged --volume ./build:/build-container-installer/build --network=host --volume /etc/containers/registries.conf:/etc/containers/registries.conf:ro  ghcr.io/jasonn3/build-container-installer:latest IMAGE_REPO=$(REMOTE_REGISTRY) IMAGE_NAME=$(IMAGE_NAME) IMAGE_TAG=$(TAG) VARIANT=bazzite VERSION=40
	export ISO_NAME=$(IMAGE_NAME)-$(TAG)-$(date +%Y%m%d-%H%M)
	mv deploy.iso $(ISO_NAME).iso
	mv deploy.iso-CHECKSUM $(ISO_NAME).iso-CHECKSUM

# Clean up built images (optional)
clean:
	podman rmi $(LOCAL_REGISTRY)/$(IMAGE_NAME):$(TAG)


