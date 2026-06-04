TF_DIR := infrastructure/environments/aws_network
BOOTSTRAP_DIR := infrastructure/bootstrap

.PHONY: bootstrap init fmt validate plan apply destroy checkov clean

bootstrap:
	cd $(BOOTSTRAP_DIR) && terraform init && terraform apply

init:
	cd $(TF_DIR) && terraform init

fmt:
	terraform fmt -recursive infrastructure

validate:
	cd $(TF_DIR) && terraform validate

plan:
	cd $(TF_DIR) && terraform plan

apply:
	cd $(TF_DIR) && terraform apply

destroy:
	cd $(TF_DIR) && terraform destroy

checkov:
	checkov -d infrastructure --quiet

clean:
	find infrastructure -type d -name .terraform -prune -exec rm -rf {} \;
	find infrastructure -type f -name '*.tfstate*' -delete
