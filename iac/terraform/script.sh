#!/bin/bash

# Update package lists and upgrade packages
sudo apt update
sudo apt upgrade -y

# Install Ansible
sudo apt install -y ansible
ansible --version

# Install Git
sudo apt install -y git-all
git --version

# Install sshpass for password-based SSH login
sudo apt-get install -y sshpass

# Create Ansible directory if it doesn't exist
sudo mkdir -p /etc/ansible

# Create Ansible hosts file
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

# Create a private and public SSH key pair if it doesn't already exist
if [ ! -f ~/.ssh/id_rsa ]; then
    sudo ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "Ansible1#12"
else
    echo "SSH key already exists, skipping key generation."
fi

# Grant execute permissions to the ~/.ssh directory
chmod 700 ~/.ssh

# Set read-only permissions for the authorized_keys file
touch ~/.ssh/authorized_keys
chmod 644 ~/.ssh/authorized_keys

# Copy the SSH public key to each host using sshpass
sudo sshpass -p 'Ansible1#12' ssh-copy-id -i ~/.ssh/id_rsa.pub logcorner@"${arg1.ipaddress}"
sudo sshpass -p 'Ansible1#12' ssh-copy-id -i ~/.ssh/id_rsa.pub logcorner@"${arg2.ipaddress}"
sudo sshpass -p 'Ansible1#12' ssh-copy-id -i ~/.ssh/id_rsa.pub logcorner@"${arg3.ipaddress}"

echo "SSH keys copied to all specified hosts."

# Additional Comments for Troubleshooting
# The error messages regarding "VMExtensionProvisioningError" indicate that there were issues executing commands on the VM.
# Ensure that you have permission to run scripts and that the SSH keys are correctly set up.

# sshpass -p 'vm-pass-word' ssh logcorner@10.3.1.5
#cat ~/.ssh/authorized_keys
