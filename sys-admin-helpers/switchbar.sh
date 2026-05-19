#!/bin/bash

if [ -f /usr/bin/wf-panel-pi ]; then
    sudo mv /usr/bin/wf-panel-pi /usr/bin/wf-panel-pi.bak
    sudo pkill wf-panel-pi
else
    sudo mv /usr/bin/wf-panel-pi.bak /usr/bin/wf-panel-pi
fi