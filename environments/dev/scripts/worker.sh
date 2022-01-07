#! /bin/bash

cat << EOF >> /etc/profile
export http_proxy=http://${server_address}:3128
export https_proxy=http://${server_address}:3128
export no_proxy=localhost,10.0.0.0/16,127.0.0.0/8,*.local
EOF

source /etc/profile

git config --global http.proxy http://${server_address}:3128
git config --global https.proxy http://${server_address}:3128

while ! curl -I --http2 -s https://www.google.com/ > /dev/nul ; do
    echo "Waiting for proxy - might be down, or still not ready installed"
    sleep 5
done

apt-get update  
apt-get install --yes vim mc aptitude python software-properties-common net-tools  
apt-add-repository --yes --update ppa:ansible/ansible  
apt-get install --yes ansible  

curl -sfL https://get.k3s.io | K3S_TOKEN="${token}" INSTALL_K3S_VERSION="v1.22.5+k3s1" K3S_URL="https://${server_address}:6443" sh -s -

git -c http.sslVerify=false clone https://github.com/a427538/terraform-k3s.git
cd terraform-k3s && git checkout "${branch}"
