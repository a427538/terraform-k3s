#! /bin/bash

if [ -z $(which ansible) ]; then 
  sudo apt-get update  
  sudo apt-get install --yes software-properties-common  
  sudo apt-add-repository --yes --update ppa:ansible/ansible  
  sudo apt-get install --yes ansible  
else
  sudo apt-get update 
  sudo apt-get install --yes ansible
fi

curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.21.5+k3s2" sh -s - \
	--write-kubeconfig-mode 644 \
	--token "${token}" \
	--tls-san "${external_lb_ip_address}" \
	--disable traefik
