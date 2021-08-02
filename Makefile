SHELL := /bin/bash
UPX_BIN      ?= $(shell which upx)
GIT_REVISION := $(shell git rev-parse --short HEAD)

BUILD_DIR   := bin
DIST_DIR    := dist-bin

GO_VERSION := 1.14.4

DOCKER_IMAGE_TAG := genconfig-builder
DOCKER_VOLS = "-v $$PWD/../../..:/src"

get-command = $(shell which="$$(which $(1) 2> /dev/null)" && if [[ ! -z "$$which" ]]; then printf %q "$$which"; fi)

DOCKER    := $(call get-command,docker)
GO        := $(call get-command,go)

.PHONY: dist clean


guard-%:
	@ if [ -z '${${*}}' ]; then echo 'Environment variable $* not set' && exit 1; fi

require-upx:
	@if [ "$(UPX_BIN)" = "" ]; then \
		echo 'Missing "upx" command. See http://upx.sourceforge.net/' && exit 1; \
	fi

$(DIST_DIR):
	mkdir -p $(DIST_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

dist-on-docker: $(DIST_DIR) docker-builder
	GO111MODULE=on go mod vendor && \
	docker run -e GIT_REVISION='$(GIT_REVISION)' \
	-v $$PWD:/src -t $(DOCKER_IMAGE_TAG) /bin/bash -c \
	'cd /src && go build -o $(DIST_DIR)/genconfig -ldflags="-X main.revision=$$GIT_REVISION"'

$(DIST_DIR)/genconfig: dist-on-docker
	upx $(DIST_DIR)/genconfig

dist: require-upx $(DIST_DIR)/genconfig

build:
	go build -ldflags="-X main.revision=${GIT_REVISION}"

clean:
	rm -rf $(DIST_DIR)

system-checks:
	@if [[ -z "$(DOCKER)" ]]; then echo 'Missing "docker" command.'; exit 1; fi && \
	if [[ -z "$(GO)" ]]; then echo 'Missing "go" command.'; exit 1; fi

docker-builder: system-checks
	DOCKER_CONTEXT=.$(DOCKER_IMAGE_TAG)-context && \
	mkdir -p $$DOCKER_CONTEXT && \
	cp Dockerfile $$DOCKER_CONTEXT && \
	docker build -t $(DOCKER_IMAGE_TAG) --build-arg go_version=go$(GO_VERSION) $$DOCKER_CONTEXT

test:
	GO111MODULE=on go test -race $$(go list ./...)
