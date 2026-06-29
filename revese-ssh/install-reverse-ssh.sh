#!/bin/bash

FILE_PATH_REVERSE_SSH_SERVICE=/etc/systemd/system/reverse_ssh.service

# on VPS machine
# sudo nano /etc/ssh/sshd_config
# > GatewayPorts yes
# sudo systemctl restart ssh

# port on master ssh VPS with use to create auto reverse ssh connection by slave machine
VPS_SSH_PORT=22
VPS_IP=93.93.79.79
VPS_USER=xxx
# port on master ssh VPS to be able to connect to slave machine by ssh
VPS_RPI_SSH_PORT=22121


ssh-keygen -t ed25519

ssh-copy-id -p $VPS_SSH_PORT $VPS_USER@$VPS_IP

sudo apt install autossh
# check autossh work
# autossh -M 0 -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -p $VPS_SSH_PORT -R $VPS_RPI_SSH_PORT:localhost:22 $VPS_USER@$VPS_IP

# sudo nano /etc/systemd/system/reverse_ssh.service
sudo tee "$FILE_PATH_REVERSE_SSH_SERVICE" > /dev/null <<EOF
[Unit]
Description=Reverse SSH Tunnel
After=network-online.target

[Service]
User=$USER

ExecStart=/usr/bin/autossh -M 0 -N -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -o "ExitOnForwardFailure yes" -p $VPS_SSH_PORT -R $VPS_RPI_SSH_PORT:localhost:22 $VPS_USER@$VPS_IP

Restart=always
RestartSec=20

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable reverse_ssh
sudo systemctl start reverse_ssh