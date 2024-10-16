#!/bin/bash
sudo apt update
sudo apt upgrade
sudo apt install -y ansible

ansible --version

sudo apt install -y git-all

git --version

#sudo git clone https://github.com/azurecorner/ansible-workshop.git

sudo mkdir -p /etc/ansible
# sudo cp ~/ansible-workshop/iac/terraform/hosts /etc/ansible/hosts

sudo tee /etc/ansible/hosts > /dev/null <<EOF
[all_hosts]
${arg1.vmname} ansible_ssh_host=${arg1.ipaddress}
${arg2.vmname} ansible_ssh_host=${arg2.ipaddress}
${arg3.vmname} ansible_ssh_host=${arg3.ipaddress}

[webserver]
${arg1.vmname}

[dbserver]
${arg2.vmname}

[appserver]
${arg3.vmname}
EOF

# #create a private and public ssh key pair

# ssh-keygen -t rsa

# #grant execute permissions to owner (virtual machine)
# chmod 755 ~/.ssh 

# #set read only permissions to the authorized_keys file

# touch ~/.ssh/authorized_keys
# chmod 644 ~/.ssh/authorized_keys

# # next we want to ssh to the ubuntu virtual machine without entering our password

# sudo ssh-copy-id logcorner@52.232.102.57
# # retrive private key
# ~/.ssh 
# cat id_rsa