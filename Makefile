UNAME := $(shell uname -s)
consul_version := 1.8.4
nomad_version := 0.12.5
vault_version := 1.5.3


.PHONY: consul vault nomad stop

### consul installation
install: download unzip

download:
ifeq ($(UNAME),Linux)
	curl -L -s https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip -o consul.zip
	curl -L -s https://releases.hashicorp.com/nomad/${nomad_version}/nomad_${nomad_version}_linux_amd64.zip -o nomad.zip
	curl -L -s https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_amd64.zip -o vault.zip
endif
ifeq ($(UNAME),Darwin)
	curl -L -s http://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_darwin_amd64.zip -o consul.zip
	curl -L -s https://releases.hashicorp.com/nomad/${nomad_version}/nomad_${nomad_version}_darwin_amd64.zip -o nomad.zip
	curl -L -s https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_darwin_amd64.zip -o vault.zip
endif

unzip:
	unzip consul.zip
	unzip nomad.zip
	unzip vault.zip
	rm consul.zip
	rm nomad.zip
	rm vault.zip
	chmod +x ./consul
	chmod +x ./nomad
	chmod +x ./vault

### consul run
consul-local:
	./consul agent -dev -config-file=consul-config.hcl

# nohup consul connect proxy -service minio-local -upstream minio:9999 -log-level debug </dev/null >/dev/null 2>&1 &
# ps -x
# sudo kill -TERM 4635
vault:
	nohup ./vault server -dev -dev-root-token-id=master -config=cluster/config/vault_config.hcl </dev/null >/dev/null 2>&1 &

nomad:
	./nomad agent -dev-connect -config=cluster/config/nomad_config.hcl

stop:
	kill $(ps aux | grep './vault server' | awk '{print $2}')

