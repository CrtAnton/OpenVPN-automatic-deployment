#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y openvpn easy-rsa expect git

sudo -u ubuntu bash -c "
cd ~
git clone https://github.com/CrtAnton/OpenVPN-automatic-deployment.git
chmod +x ~/OpenVPN-automatic-deployment/scripts/*
"

echo "EXPORTING ENV VARIABLES..."
cat <<EOF | sudo tee /etc/openvpn/config.env
export ROOT_PASSPHRASE="${Root_Passphrase}"
export ROOT_CA_NAME="${Root_CA_Name}"
EOF

sudo chmod 644 /etc/openvpn/config.env
sudo chown ubuntu:ubuntu /etc/openvpn/config.env
echo "source /etc/openvpn/config.env" | sudo tee -a /home/ubuntu/.bashrc

sudo -u ubuntu bash -c "
source /etc/openvpn/config.env
cd ~
make-cadir ~/easy-rsa-root && cd ~/easy-rsa-root
./easyrsa init-pki
~/OpenVPN-automatic-deployment/scripts/create-ca.sh \"\$ROOT_CA_NAME\" \"\$ROOT_PASSPHRASE\"
"
