## pakapp Installation

```bash
    git clone https://github.com/xMadCore/admk-utilities.git
```
```
    # dir structure after

    home/user/
    ├── admk-utilities/
    │   ├── reverse-ssh/
    │   ├── sys-admin-helpers/
    │   ├── config.txt
    │   ├── install-config.sh
    │   ├── pre-install-tests.sh
    │   ├── install-pakapp.sh
    │   ├── post-install-tests.sh
    │   └── ...
    ├── config/
        └── ...
    ├── pakapp
    └── Documents/
        └── wallpaper.png
```
```bash
    cd admk-utilities

    chmod +x install-config.sh
    chmod +x pre-install-tests.sh
    chmod +x install-pakapp.sh
    chmod +x post-install-tests.sh

    ./install-config.sh

    sudo reboot

    ./pre-install-tests.sh

    # Заменить
    # BOOT_UART=0 
    # DISABLE_HDMI_TERMINAL=1
    ./install-pakapp.sh

    ./post-install-tests.sh

    sudo reboot # sudo poweroff
```