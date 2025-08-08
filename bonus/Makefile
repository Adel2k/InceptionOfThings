# Makefile

all: create-cluster create-ns install-gitlab deploy

create-cluster:
	chmod +x scripts/create-cluster.sh
	./scripts/create-cluster.sh

create-ns:
	chmod +x scripts/create-ns.sh
	./scripts/create-ns.sh

install-gitlab:
	chmod +x scripts/install-gitlab.sh
	./scripts/install-gitlab.sh

deploy:
	chmod +x scripts/deploy.sh
	./scripts/deploy.sh

clean:
	chmod +x scripts/delete.sh
	./scripts/delete.sh

.PHONY: create-cluster create-ns install-gitlab deploy all