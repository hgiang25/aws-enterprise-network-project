ENV ?= dev
TF_DIR := terraform/environments/$(ENV)

.PHONY: init fmt validate plan apply destroy checkov tflint docs clean

init:
	cd $(TF_DIR) && terraform init

fmt:
	terraform fmt -recursive terraform

validate:
	cd $(TF_DIR) && terraform validate

plan:
	cd $(TF_DIR) && terraform plan

apply:
	cd $(TF_DIR) && terraform apply

destroy:
	cd $(TF_DIR) && terraform destroy

checkov:
	checkov -d terraform --quiet

tflint:
	cd $(TF_DIR) && tflint --init && tflint

docs:
	bash scripts/generate-docs.sh

clean:
	find terraform -type d -name .terraform -prune -exec rm -rf {} \;
	find terraform -type f -name '*.tfstate*' -delete
