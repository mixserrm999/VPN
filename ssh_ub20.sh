#!/bin/bash
#script by jiraphat yuenying

wget -O /etc/ssh/sshd_config 'https://raw.githubusercontent.com/mixserrm999/VPN/main/sshd_config'

systemctl restart ssh
