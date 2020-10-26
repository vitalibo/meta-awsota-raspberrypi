BRANCH=$(shell git branch --show-current)

.PHONY: help
help:
	@echo "Usage: make (setup|bitbake|http_server|shutdown)"
	@echo ""
	@echo "  setup        Synchronize code sources and setup VM."
	@echo "  bitbake      Invoke BitBake build tool inside VirtualBox."
	@echo "  http_server  Setup HTTP server to browse build results."
	@echo "  shutdown     Destroy current VM."
	@echo ""

.PHONY: setup
setup:
	repo init -u https://github.com/vitalibo/meta-awsota-raspberrypi -m manifest.xml -b $(BRANCH)
	repo sync
	vagrant up

.PHONY: bitbake
bitbake:
	vagrant ssh -c 'bitbake $(filter-out $@,$(MAKECMDGOALS))'

.PHONY: http_server
http_server:
	vagrant ssh -c 'cd /project/build && python3 -m http.server'

.PHONY: shutdown
shutdown:
	vagrant destroy
