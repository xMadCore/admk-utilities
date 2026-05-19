#!/bin/bash
VPS_SSH_PORT=22
VPS_IP=93.93.79.79
VPS_USER=xxx

sudo date -u -s "$(ssh -p $VPS_SSH_PORT $VPS_USER@$VPS_IP 'date -u "+%Y-%m-%d %H:%M:%S"')"