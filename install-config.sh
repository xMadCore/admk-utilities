#!/bin/bash
# --- STAGE 2.1 ---
FILE_PATH="/boot/firmware/config.txt"
SOURCE_CONFIG="./config.txt"

sudo mv $FILE_PATH "$FILE_PATH.bak"
sudo cp -f "$SOURCE_CONFIG" "$FILE_PATH"

# sudo reboot 