#!/bin/bash
sudo apt update
sudo apt upgrade
sudo apt install -y ansible

ansible --version

sudo apt install -y git-all

git --version

sudo sudo apt-get install sshpass


#sudo git clone https://github.com/azurecorner/ansible-workshop.git
#cd ansible-workshop/ansible

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

sudo ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "Ansible1#12"

# #grant execute permissions to owner (virtual machine)
 chmod 755 ~/.ssh 

# #set read only permissions to the authorized_keys file

 touch ~/.ssh/authorized_keys
 chmod 644 ~/.ssh/authorized_keys

# # next we want to ssh to the ubuntu virtual machine without entering our password

# sudo ssh-copy-id logcorner@10.3.1.5

# # we can also use sshpass to ssh to the virtual machine without entering our password

# sudo sshpass -p 'Ansible1#12' ssh-copy-id -i ~/.ssh/id_rsa.pub logcorner@"${arg1.ipaddress}"
# sudo sshpass -p 'Ansible1#12' ssh-copy-id -i ~/.ssh/id_rsa.pub logcorner@"${arg2.ipaddress}"
# sudo sshpass -p 'Ansible1#12' ssh-copy-id -i ~/.ssh/id_rsa.pub logcorner@"${arg3.ipaddress}"

## sshpass -p 'vm-pass-word' ssh logcorner@10.3.1.5
## cat ~/.ssh/authorized_keys

# # retrive private key
# ~/.ssh 
# cat id_rsa