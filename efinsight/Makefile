include ../settings.mk

MODULE_NAME = commanderinsight

include ../template.mk

build:
	cp -f /tmp/$(INSIGHT_INSTALLER) ./$(INSIGHT_INSTALLER)
	docker build -t kin3303/$(MODULE_NAME):$(TAG) --build-arg INSIGHT_INSTALLER=$(INSIGHT_INSTALLER) .
	rm -f ./$(INSIGHT_INSTALLER)
