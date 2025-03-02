#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y openvpn easy-rsa expect git

sudo -u ubuntu bash -c "
cd ~
git clone -b develop --single-branch https://github.com/CrtAnton/OpenVPN-automatic-deployment.git
cd ~/OpenVPN-automatic-deployment
git pull origin develop
chmod +x ~/OpenVPN-automatic-deployment/scripts/*
"


echo "EXPORTING ENV VARIABLES..."
cat <<EOF | sudo tee /etc/openvpn/config.env
export ROOT_PASSPHRASE="${Root_Passphrase}"
export ROOT_CA_NAME="${Root_CA_Name}"
export INTERMEDIATE_PASSPHRASE="${Intermediate_Passphrase}"
export INTERMEDIATE_CA_NAME="${Intermediate_CA_Name}"
EOF

sudo chmod 644 /etc/openvpn/config.env
sudo chown ubuntu:ubuntu /etc/openvpn/config.env
echo "source /etc/openvpn/config.env" | sudo tee -a /home/ubuntu/.bashrc

sudo -u ubuntu bash -c "
source /etc/openvpn/config.env
cd ~
make-cadir ~/easy-rsa-root && cd ~/easy-rsa-root
./easyrsa init-pki
~/OpenVPN-automatic-deployment/scripts/create-ca.sh \"\$ROOT_PASSPHRASE\" \"\$ROOT_CA_NAME\" 

make-cadir ~/easy-rsa-intermediate && cd ~/easy-rsa-intermediate
./easyrsa init-pki
cp ~/easy-rsa-root/pki/ca.crt pki/
~/OpenVPN-automatic-deployment/scripts/create-intermediate.sh \"\$INTERMEDIATE_PASSPHRASE\" \"\$INTERMEDIATE_CA_NAME\"
cp ~/easy-rsa-intermediate/pki/reqs/intermediate.req ~/easy-rsa-root/pki/reqs/
cd ~/easy-rsa-root
~/OpenVPN-automatic-deployment/scripts/root-signer.sh \"\$ROOT_PASSPHRASE\"
mkdir -p ~/easy-rsa-intermediate/pki/issued/
cp pki/issued/intermediate.crt ~/easy-rsa-intermediate/pki/issued/
"
