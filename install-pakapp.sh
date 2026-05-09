#!/bin/bash
# --- STAGE 2.4 ---
sudo apt update && sudo apt upgrade -y

#sudo apt install libcamera-apps -y #Опционально

# Включение WLAN
sudo nmcli radio wifi on

# присвоить группы
sudo usermod -aG lp,tty,input,video,plugdev,i2c,dialout,netdev $USER


FILE_PATH="/etc/udev/rules.d/99-hidraw.rules"
CONTENT='KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", GROUP="plugdev"'
echo "$CONTENT" | sudo tee "$FILE_PATH" > /dev/null


FILE_PATH="/etc/udev/rules.d/99-medical.rules"
sudo tee "$FILE_PATH" > /dev/null <<EOF
# Правило для доступа через libusb
SUBSYSTEM=="usb", ATTRS{idVendor}=="04d9", ATTRS{idProduct}=="b554", MODE="0666", GROUP="plugdev"

# Правило для доступа через hidraw
KERNEL=="hidraw*", ATTRS{idVendor}=="04d9", ATTRS{idProduct}=="b554", MODE="0666", GROUP="plugdev"
EOF


FILE_PATH="/etc/udev/rules.d/99-medical-hid.rules"
sudo tee "$FILE_PATH" > /dev/null <<EOF
# Даем права группе plugdev на все hidraw устройства
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", GROUP="plugdev"

# Конкретно для твоего USB-устройства
SUBSYSTEM=="usb", ATTRS{idVendor}=="04d9", ATTRS{idProduct}=="b554", MODE="0666", GROUP="plugdev"
EOF


sudo udevadm control --reload-rules
sudo udevadm trigger


# sudo raspi-config
# Interface Options -> Serial Port.
# На вопрос "Would you like a login shell to be accessible over serial?" –  No.
# На вопрос "Would you like the serial port hardware to be enabled?" – Yes.
sudo raspi-config nonint do_serial_hw 0
sudo raspi-config nonint do_serial_cons 1

# Также выполнить команду
echo -1 | sudo tee /sys/bus/usb/devices/usb*/power/autosuspend


FILE_PATH="/etc/polkit-1/rules.d/10-network-manager.rules"
sudo tee "$FILE_PATH" > /dev/null <<EOF
polkit.addRule(function(action, subject) {
    if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 &&
        subject.isInGroup("netdev")) {
        return polkit.Result.YES;
    }
});
EOF

sudo cp -rf ~/config/ /opt/config
sudo cp -f ~/pakapp /opt/pakapp
sudo chmod +x /opt/pakapp
sudo chown root:root /opt/pakapp

sudo mkdir -p /opt/exam_video
sudo chown $USER:$(id -gn) /opt/exam_video
sudo chmod 755 /opt/exam_video


sudo apt-get install -y \
libhidapi-libusb0 \
libqt6sql6 \
libqt6serialport6 \
libqt6network6 \
libqt6gui6 \
libqt6core6t64 \
libqt6widgets6 \
network-manager \
i2c-tools \
libgstreamer1.0-0 \
gstreamer1.0-plugins-base \
gstreamer1.0-plugins-good \
gstreamer1.0-libcamera \
ca-certificates \
libssl3t64 \
libgstreamer1.0-dev \
libgstreamer-plugins-base1.0-dev \
gstreamer1.0-tools \
gstreamer1.0-plugins-base \
gstreamer1.0-plugins-good \
gstreamer1.0-plugins-bad \
gstreamer1.0-plugins-ugly \
gstreamer1.0-libav


FILE_PATH="/etc/systemd/system/pakapp.service"
sudo tee "$FILE_PATH" > /dev/null <<EOF
[Unit]
Description=My Qt PAK ADMK or UMKA Kiosk Project
After=network.target multi-user.target

[Service]
User=$USER
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/$USER/.Xauthority
Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "$USER")/bus

WorkingDirectory=/opt/
ExecStart=/opt/pakapp
ExecStartPre=/bin/sleep 5
# Autorestart
Restart=always
RestartSec=5

[Install]
WantedBy=graphical.target
Wants=graphical.target
EOF


sudo systemctl daemon-reload
sudo systemctl enable pakapp.service
sudo systemctl start pakapp.service


sudo mv /usr/bin/wf-panel-pi /usr/bin/wf-panel-pi.bak
sudo pkill wf-panel-pi

pcmanfm --set-wallpaper  ~/Documents/wallpaper.png --wallpaper-mode=stretch

FILE_PATH="/boot/firmware/cmdline.txt"
# заменить console=tty1 на console=tty3
sudo sed -i 's/console=tty1/console=tty3/' "$FILE_PATH"
# добавить logo.nologo
if ! grep -q "logo.nologo" "$FILE_PATH"; then
    sudo sed -i 's/$/ logo.nologo/' "$FILE_PATH"
fi
# добавить vt.global_cursor_default=0 (убирает курсор)
if ! grep -q "vt.global_cursor_default=0" "$FILE_PATH"; then
    sudo sed -i 's/$/ vt.global_cursor_default=0/' "$FILE_PATH"
fi


# --- STAGE 4.3 ---
# --- INTERACTIVE! ---

# Заменить
# BOOT_UART=0 
# DISABLE_HDMI_TERMINAL=1
sudo rpi-eeprom-config --edit

# --- NON INTERACTIVE ---
sudo mkdir -p /usr/share/plymouth/themes/medical_kiosk
sudo cp -f ~/Documents/wallpaper.png /usr/share/plymouth/themes/medical_kiosk/splash.png

FILE_PATH="/usr/share/plymouth/themes/medical_kiosk/medical_kiosk.plymouth"
sudo tee "$FILE_PATH" > /dev/null <<EOF
[Plymouth Theme] 
Name=Medical Kiosk Splash 
Description=Custom brand logo for medical device 
ModuleName=script 
[script] 
ImageDir=/usr/share/plymouth/themes/medical_kiosk 
ScriptFile=/usr/share/plymouth/themes/medical_kiosk/medical_kiosk.script
EOF

FILE_PATH="/usr/share/plymouth/themes/medical_kiosk/medical_kiosk.script"
sudo tee "$FILE_PATH" > /dev/null <<EOF
# Получаем размеры окна (экрана) 
screen_width = Window.GetWidth(); 
screen_height = Window.GetHeight(); 
# Загружаем изображение 
resized_image = Image("splash.png"); 
# Масштабируем изображение под размер экрана 
# ВАЖНО: Это растянет картинку даже если соотношение сторон не совпадает. 
resized_image = resized_image.Scale(screen_width, screen_height); 
# Создаем спрайт и размещаем его (в 0,0, так как он на весь экран) 
sprite = Sprite(resized_image); 
sprite.SetX(0); 
sprite.SetY(0); 
# Устанавливаем самый низкий z-слой (фон) 
sprite.SetZ(-10);
EOF

sudo plymouth-set-default-theme -R medical_kiosk

echo "Go Reboot :3 "