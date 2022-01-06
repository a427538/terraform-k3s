#!/bin/bash -xe

apt-get update
apt-get install --yes vim mc aptitude python software-properties-common net-tools
apt-add-repository --yes --update ppa:ansible/ansible  
apt-get install --yes ansible

git clone https://github.com/a427538/terraform-k3s.git
cd terraform-k3s && git checkout "${branch}"

curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.22.5+k3s1" sh -s - \
    --write-kubeconfig-mode 644 \
	--token "${token}" \
	--tls-san "${external_lb_ip_address}" \  
	--disable traefik
    # --cluster-cidr 10.42.0.0/16
    # --flannel-backend none \
    # --disable-network-policy \  


# # Enable ip forwarding and nat
# sysctl -w net.ipv4.ip_forward=1
# 
# # Make forwarding persistent.
# sed -i= 's/^[# ]*net.ipv4.ip_forward=[[:digit:]]/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
# 
# iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE
