#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
# install base packages
apt install --yes micro curl tree git
echo "EDITOR=/usr/bin/micro" >>/etc/environment

# install ansible and its dependencies
apt install --yes manpages man-db gnupg2 ansible jq

# Enable ssh
apt install --yes openssh-server
systemctl enable ssh
systemctl start ssh
command -v ufw && ufw allow ssh
