BRANCH=$(shell git branch --show-current)

.PHONY: help
help:
	@echo "Usage: make (init|sync|build)"

.PHONY: init
init:
	repo init -u git@github.com:vitalibo/meta-awsota-raspberrypi.git -m manifest.xml -b $(BRANCH)

.PHONY: sync
sync:
	repo sync

.PHONY: build
build:
	source src/poky/oe-init-build-env build
	bitbake core-image-lsb
