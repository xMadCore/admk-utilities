#!/bin/bash
FILE_PATH_CONFIG_DIR=~/config
FILE_PATH_PAKAPP=~/pakapp

sudo systemctl stop pakapp.service

sudo cp -rf $FILE_PATH_CONFIG_DIR /opt/config
sudo cp -f $FILE_PATH_PAKAPP /opt/pakapp
sudo chmod +x /opt/pakapp
sudo chown root:root /opt/pakapp

sudo systemctl restart pakapp.service