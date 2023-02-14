#
#
#
.ONESHELL:
.SHELL := /bin/bash
.PHONY: common
.EXPORT_ALL_VARIABLES:
CURRENT_FOLDER=$(shell basename "$$(pwd)")
ENVIRONMENT ?= dev
EXTRA ?= "-e 'makefile=true' -v"
PASSWORD_FILE ?= ~/.vault_pass.txt
# Bug running on OSX
OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
ANSIBLE_USER=vagrant
VAGRANT_IP=$(shell vagrant ssh -c "hostname -I | cut -d' ' -f2" 2> /dev/null)
INVENTORY=$(VAGRANT_IP),
RED='\033[0;31m'
GREEN='\032[0;31m'
RESET='\033[0m'
BOLD='\033[31;1;4m'

# Default to use pipenv unless disabled
PIPENV=true
ifeq ($(PIPENV),true)
PIPENVCMD=pipenv run
else
PIPENVCMD=
endif

check-env:
	@if [ ! "$(ENVIRONMENT)" ]; then echo "$(BOLD)$(RED)ENVIRONMENT is not set$(RESET)"; exit 1;fi

check: ## run pre-commit tests
	@${PIPENVCMD} pre-commit run --all-files

help: ## This help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: check-env ## Runs the playbook to install Kubernetes
	@${PIPENVCMD} ansible-playbook -i ${INVENTORY} sample.yml --diff -u ${ANSIBLE_USER} \
		-e env=$(ENVIRONMENT) -e vagrant_ip=$(VAGRANT_IP) ${EXTRA}
	
helm: check-env ## Deploy helm charts
	@${PIPENVCMD} ansible-playbook -i ${INVENTORY} sample.yml --diff -u ${ANSIBLE_USER} \
		-e env=$(ENVIRONMENT) -e vagrant_ip=$(VAGRANT_IP) ${EXTRA} --tags helm

argocd: check-env ## Install ArgoCD
	@${PIPENVCMD} ansible-playbook -i ${INVENTORY} sample.yml --diff -u ${ANSIBLE_USER} \
		-e env=$(ENVIRONMENT) -e vagrant_ip=$(VAGRANT_IP) ${EXTRA} --tags argocd