.PHONY: $(COMMON_TARGETS)

all: build push pull

build:
	cp -f /tmp/$(FLOW_INSTALLER) ./$(FLOW_INSTALLER)
	docker build -t kin3303/$(MODULE_NAME):$(TAG) --build-arg FLOW_INSTALLER=$(FLOW_INSTALLER) .
	rm -f ./$(FLOW_INSTALLER)

push: build
	docker push kin3303/$(MODULE_NAME):$(TAG)

pull: 
	docker pull kin3303/$(MODULE_NAME):$(TAG)

save: pull
	docker save -o ../images/$(MODULE_NAME)_$(TAG).tar kin3303/$(MODULE_NAME):$(TAG)
    
load:
	docker load -i ../images/$(MODULE_NAME)_$(TAG).tar

clean: cleandata

cleandata:
	rm -rf $(PWD)/data/plugins/*
	rm -rf $(PWD)/data/workspace/*
	rm -rf $(PWD)/data/repository-data/*
	rm -rf $(PWD)/data/insight-data/*
	rm -rf $(PWD)/data/license/*
