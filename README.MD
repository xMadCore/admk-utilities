# pakapp Installation

```bash
    cd admk-utilites

    chmod +x install-config.sh
    chmod +x pre-install-tests.sh
    chmod +x install-pakapp.sh
    chmod +x post-install-tests.sh

    ./install-config.sh

    sudo reboot

    ./pre-install-tests.sh

    # move wallpaper.png to ~/Documents/wallpaper.png
    # move dir config -> ~/config
    # move pakapp -> ~/pakapp

    ./install-pakapp.sh

    ./post-install-tests.sh

    sudo reboot # sudo poweroff
```