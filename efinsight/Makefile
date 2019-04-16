include ../settings.mk

MODULE_NAME = commanderinsight

include ../template.mk

build:
	cp -f /tmp/$(EFLOW_DEV_INSTALLER) ./$(EFLOW_DEV_INSTALLER)
	docker build -t kin3303/$(MODULE_NAME):$(TAG) --build-arg EFLOW_DEV_INSTALLER=$(EFLOW_DEV_INSTALLER) .
	rm -f ./$(EFLOW_DEV_INSTALLER)
