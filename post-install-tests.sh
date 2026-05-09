#!/bin/bash
# > TEST smoll check rules
ls -l /dev/hidraw*


# TEST serial port
# включен ли порт (0 = да, 1 = нет). | должен быть 0
sudo raspi-config nonint get_serial_hw

# включена ли консоль (0 = да, 1 = нет). | должен быть 1
sudo raspi-config nonint get_serial_cons