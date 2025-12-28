#!/usr/bin/env bash

os_like="$(grep -e '^ID_LIKE=' /etc/os-release | cut -d '=' -f2 | tr -d '\"')"

# Setup firewall before using rustdesk
if command -v firewall-cmd &>/dev/null && [[ $os_like == *"rhel" ]]; then
	firewall-cmd --permanent --new-service=rustdesk
	firewall-cmd --permanent --service=rustdesk --set-description='Ports which are necessary to operate with rustdesk'
	firewall-cmd --permanent --service=rustdesk --add-port=21115/tcp
	firewall-cmd --permanent --service=rustdesk --add-port=21116/tcp
	firewall-cmd --permanent --service=rustdesk --add-port=21116/udp
	firewall-cmd --permanent --service=rustdesk --add-port=21118/tcp
	firewall-cmd --permanent --service=rustdesk --add-port=21117/tcp
	firewall-cmd --permanent --service=rustdesk --add-port=21119/tcp
	firewall-cmd --permanent --zone=public --add-service=rustdesk
	firewall-cmd --reload
fi

if command -v ufw &>/dev/null && [[ ${os_like} == *"debian"* ]]; then
	ufw allow 21114:21119/tcp comment 'rustdesk Server'
	ufw allow 21116/udp comment 'rustdesk server'
fi
