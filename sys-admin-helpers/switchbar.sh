#!/bin/bash

if [ -f /usr/bin/wf-panel-pi ]; then
    mv /usr/bin/wf-panel-pi /usr/bin/wf-panel-pi.bak
    pkill wf-panel-pi
else
    mv /usr/bin/wf-panel-pi.bak /usr/bin/wf-panel-pi
fi