SHELL=/bin/bash
# SERVER_NAME         = $(subst _,.,$(subst -,.,$(notdir $(CURDIR))))
SERVER_NAME         = socket.com
MYSQL_ROOT_PASSWORD = ${SERVER_NAME}
MYSQL_DATABASE      = ${SERVER_NAME}
MYSQL_USER          = ${SERVER_NAME}
MYSQL_PASSWORD      = ${SERVER_NAME}
WORKING_DIR         = /var/www
NGINX_ROOT          = ${WORKING_DIR}
IS_PROVISION        = false 


ifeq (${IS_PROVISION}, true)
	RESTART = always
	FILE_NAME = docker-compose-pov.yml
else
	RESTART = no
	FILE_NAME = docker-compose-dev.yml
endif
.PHONY: test
test:
	@echo $(filter-out $@,$(MAKECMDGOALS)) 
	@echo $(SHELL)
	@echo NGINX_ROOT: $(NGINX_ROOT)
	@echo IS_PROVISION: $(IS_PROVISION)
	@echo SERVER_NAME: $(SERVER_NAME)
	@echo MYSQL_USER: ${MYSQL_USER}
	@echo MYSQL_PASSWORD: ${MYSQL_PASSWORD}
	@echo MYSQL_DATABASE: ${MYSQL_DATABASE}
	@echo MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
	@echo RESTART: ${RESTART}

.PHONY: install
install: 
	# @if [ true != $(IS_PROVISION) ];then chmod +x .docker/install.sh && .docker/install.sh; fi;
	cd $(PWD)/.docker/ && \
		export SERVER_NAME=$(SERVER_NAME) && \
		export IS_PROVISION=$(IS_PROVISION) && \
		export NGINX_ROOT=$(NGINX_ROOT) && \
		export WORKING_DIR=$(WORKING_DIR) && \
		export MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) && \
		export MYSQL_DATABASE=$(MYSQL_DATABASE) && \
		export MYSQL_USER=$(MYSQL_USER) && \
		export MYSQL_PASSWORD=$(MYSQL_PASSWORD) && \
		export RESTART=$(RESTART) && \
		docker-compose -f $(FILE_NAME) -p $(SERVER_NAME) up --build --force-recreate -d
up:
	cd $(PWD)/.docker/ && \
		export SERVER_NAME=$(SERVER_NAME) && \
		export IS_PROVISION=$(IS_PROVISION) && \
		export NGINX_ROOT=$(NGINX_ROOT) && \
		export WORKING_DIR=$(WORKING_DIR) && \
		export MYSQL_ROOT_PASSWORD=$(MYSQL_ROOT_PASSWORD) && \
		export MYSQL_DATABASE=$(MYSQL_DATABASE) && \
		export MYSQL_USER=$(MYSQL_USER) && \
		export MYSQL_PASSWORD=$(MYSQL_PASSWORD) && \
		export RESTART=$(RESTART) && \
		docker-compose -f $(FILE_NAME) -p $(SERVER_NAME) up -d
logs:
	cd $(PWD)/.docker/ && \
	export SERVER_NAME=$(SERVER_NAME) && \
	docker-compose -p $(SERVER_NAME) -f $(FILE_NAME) logs --follow

.PHONY: remove
remove: 
	cd $(PWD)/.docker/ && \
	docker-compose -p $(SERVER_NAME) -f $(FILE_NAME) down
	sudo sh -c "sed -i -e 's/127.0.0.1   $(SERVER_NAME)//g' /etc/hosts"
down:
	cd $(PWD)/.docker/ && \
	docker-compose -p $(SERVER_NAME) -f $(FILE_NAME) down
monitor:
	docker stats $(docker inspect -f {{.NAME}} $(docker ps -q))

.PHONY: ssh $(t)
ssh:
	docker exec -it $(SERVER_NAME).$(filter-out $@,$(MAKECMDGOALS)) /bin/bash
%:
	@:
