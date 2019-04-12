include ../settings.mk

MODULE_NAME = commanderdb

include ../template.mk

push:
	docker push kin3303/$(MODULE_NAME)

pull:
	docker pull kin3303/$(MODULE_NAME)

build:
	docker build -t kin3303/$(MODULE_NAME) .
