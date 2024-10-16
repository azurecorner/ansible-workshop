terraform init -var-file="dev.tfvars"
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"


cat /etc/ansible/hosts


ansible-inventory --list

ansible  -m ping all_hosts


ansible  -m ping webservers

ansible  -m ping dbservers
