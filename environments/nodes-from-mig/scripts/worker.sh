#! /bin/bash

apt-get update  
apt-get install --yes software-properties-common  
apt-add-repository --yes --update ppa:ansible/ansible  
apt-get install --yes ansible  

curl -sfL https://get.k3s.io | K3S_TOKEN="${token}" INSTALL_K3S_VERSION="v1.21.5+k3s2" K3S_URL="https://${server_address}:6443" sh -s - 