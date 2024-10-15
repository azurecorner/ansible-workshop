#!/bin/bash
echo "The first argument passed is: ${arg1}"
echo "The second argument passed is: ${arg2}"
echo "The third argument passed is: ${arg3}"

sudo apt update
sudo apt upgrade
sudo apt install -y ansible

ansible --version
