VERSION ?= $(shell git describe --tags --exact-match 2>/dev/null || echo latest)

SHORT_NAME := shell-dev
REGISTRY ?= quay.io/
IMAGE_PREFIX ?= deis
IMAGE := ${REGISTRY}${IMAGE_PREFIX}/${SHORT_NAME}:${VERSION}

build:
	docker build -t ${IMAGE} .

push: build
	docker push ${IMAGE}
