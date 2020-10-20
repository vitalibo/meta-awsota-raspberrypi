BRANCH=$(shell git branch --show-current)

.PHONY: help
help:
	@echo "Usage: make (setup|destroy)"

.PHONY: setup
setup:
	repo init -u git@github.com:vitalibo/meta-awsota-raspberrypi.git -m manifest.xml -b $(BRANCH)
	repo sync
	vagrant up

.PHONY: destroy
destroy:
	vagrant destroy
