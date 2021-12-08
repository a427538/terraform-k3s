#! /bin/bash

apt-get update  
apt-get install --yes software-properties-common  
apt-add-repository --yes --update ppa:ansible/ansible  
apt-get install --yes ansible  

curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.21.5+k3s2" sh -s - \
	--write-kubeconfig-mode 644 \
	--token "${token}" \
	--tls-san "${external_lb_ip_address}" \
	--disable traefik
