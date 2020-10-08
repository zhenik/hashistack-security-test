.ONESHELL .PHONY: dev clean destroy-box remove-tmp

dev:
	SSL_CERT_FILE=${SSL_CERT_FILE} CURL_CA_BUNDLE=${CURL_CA_BUNDLE} CUSTOM_CA=${CUSTOM_CA} ANSIBLE_ARGS='--skip-tags "test"' vagrant up --provision

# clean commands
remove-tmp:
	rm -rf ./tmp
	rm -rf ./.vagrant
	rm -rf ./.minio.sys
	rm -rf ./example/.terraform
	rm -rf ./example/terraform.tfstate
	rm -rf ./example/terraform.tfstate.backup
destroy-box:
	vagrant destroy -f

clean: destroy-box remove-tmp
