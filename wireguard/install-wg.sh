#!/bin/bash
INTERFACE_NAME=wg0
FILE_PATH_WG_CONF=/etc/wireguard/wg0.conf
FILE_PATH_WG_PUBLIC_KEY=/etc/wireguard/public.key
FILE_PATH_WG_PRIVATE_KEY=/etc/wireguard/private.key

SERVER_WG_IP=87.87.202.202
SERVER_WG_PORT=51820
SERVER_WG_PUBKEY="Key1/public="

CLIENT_IP="192.168.223.200"
CLIENT_AllowedIPs="192.168.223.0/24, 192.168.222.0/24"

if [[ $EUID -ne 0 ]]; then
   echo "run script with root (sudo) permissions"
   exit 1
fi

apt update
apt update && apt install -y wireguard wireguard-tools

mkdir -p /etc/wireguard
cd /etc/wireguard

if [ ! -f $FILE_PATH_WG_PRIVATE_KEY ]; then
    wg genkey | tee $FILE_PATH_WG_PRIVATE_KEY | wg pubkey > $FILE_PATH_WG_PUBLIC_KEY
    # wg genpsk > preshared.key
    chmod 600 $FILE_PATH_WG_PRIVATE_KEY $FILE_PATH_WG_PUBLIC_KEY
fi

PRIVAT_KEY=$(cat "$FILE_PATH_WG_PRIVATE_KEY")
PUBLIC_KEY=$(cat "$FILE_PATH_WG_PUBLIC_KEY")

tee $FILE_PATH_WG_CONF > /dev/null <<EOF
[Interface]
PrivateKey = $PRIVAT_KEY
Address = $CLIENT_IP/24

[Peer]
PublicKey = $SERVER_WG_PUBKEY
Endpoint = $SERVER_WG_IP:$SERVER_WG_PORT
AllowedIPs = $CLIENT_AllowedIPs
PersistentKeepalive = 25
EOF


chmod 600 /etc/wireguard/*

systemctl enable wg-quick@$INTERFACE_NAME
systemctl start wg-quick@$INTERFACE_NAME

printf "\nPublic Key for SERVER_WG:\n\n"
cat $FILE_PATH_WG_PUBLIC_KEY
printf "\n"

# update config on SERVER_WG
# sudo wg syncconf wg0 <(wg-quick strip wg0)