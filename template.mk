.PHONY: $(COMMON_TARGETS)

all: build push pull

build:
	cp -f ../$(EFLOW_INSTALLER) ./$(EFLOW_INSTALLER)
	docker build -t kin3303/$(MODULE_NAME):$(TAG) --build-arg EFLOW_INSTALLER=$(EFLOW_INSTALLER) .
	rm -f ./$(EFLOW_INSTALLER)

push: build
	docker push kin3303/$(MODULE_NAME):$(TAG)

pull: 
	docker pull kin3303/$(MODULE_NAME):$(TAG)

save: pull
	docker save -o ../images/$(MODULE_NAME)_$(TAG).tar kin3303/$(MODULE_NAME):$(TAG)
    
load:
	docker load -i ../images/$(MODULE_NAME)_$(TAG).tar

clean: cleandata

cleanall: cleandata cleanimages

cleanimages:
	docker rmi kin3303/$(MODULE_NAME):$(TAG)

cleandata:
	rm -rf $(PWD)/data/db-data/*
	rm -rf $(PWD)/data/zoo/*
	rm -rf $(PWD)/data/plugins/*
	rm -rf $(PWD)/data/workspace/*
	rm -rf $(PWD)/data/repository-data/*
	rm -f  $(PWD)/data/conf/*_ready
	rm -rf $(PWD)/data/logs/*
	rm -rf $(PWD)/data/conf/tmp*
	rm -rf $(PWD)/data/haproxy/haproxy.cfg

cleankeepdata:
	rm -rf $(PWD)/data/db-data/*
	rm -rf $(PWD)/data/zoo/*
	rm -f  $(PWD)/data/conf/*_ready
	rm -rf $(PWD)/data/logs/*
	rm -rf $(PWD)/data/conf/tmp*
	rm -rf $(PWD)/data/haproxy/haproxy.cfg
