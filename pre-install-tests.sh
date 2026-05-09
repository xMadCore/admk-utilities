# > TEST groups exist
# grep -E 'lp:|tty:|input:|video:|plugdev:|i2c:|dialout:|netdev:' /etc/group
COUNT=$(grep -E 'lp:|tty:|input:|video:|plugdev:|i2c:|dialout:|netdev:' /etc/group | wc -l)
if [ "$COUNT" -ge 8 ]; then
    echo "[  OK  ] Штатное поведение все группы существуют"
else
    echo "[ FAIL ] Не существует каких-то групп"
    grep -E 'lp:|tty:|input:|video:|plugdev:|i2c:|dialout:|netdev:' /etc/group
fi


# > TEST meteo
# работает только после правки /boot/firmware/config.txt (dtparam=i2c_arm=on)
# i2cdetect -y 1
#      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
# 00:                         -- 09 -- -- -- -- -- -- 
# 10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
# 20: -- -- -- -- -- -- -- -- -- 29 -- -- -- -- -- -- 
# 30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
# 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
# 50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
# 60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
# 70: -- -- -- -- -- -- -- --                        

# BUS=1

LIGHT_SENSOR_ADDR="29"
if i2cdetect -y 1 | grep -q -E "\b$LIGHT_SENSOR_ADDR\b"; then
    echo "[  OK  ] Light Sensor 0x$LIGHT_SENSOR_ADDR обнаружен."
else
    echo "[ FAIL ] Light Sensor 0x$LIGHT_SENSOR_ADDR НЕ НАЙДЕН!"
fi

TREMA_MODULE_ADDR="09"
if i2cdetect -y 1 | grep -q -E "\b$TREMA_MODULE_ADDR\b"; then
    echo "[  OK  ] Trema Module 0x$TREMA_MODULE_ADDR обнаружен."
else
    echo "[ FAIL ] Trema Module 0x$TREMA_MODULE_ADDR НЕ НАЙДЕН!"
fi


# > TEST devices (medical pref)
# lsusb
# 04d9:b554 – Тонометр
# 0483:5740 – Алкотестер
# 10c4:ea60 – Термометр
# lsusb | grep 04d9:b554
# lsusb | grep 0483:5740
# lsusb | grep 10c4:ea60
if lsusb | grep -q 04d9:b554; then
    echo "[  OK  ] Тонометр обнаружен."
else
    echo "[ FAIL ] Тонометр НЕ НАЙДЕН!"
fi

if lsusb | grep -q 0483:5740; then
    echo "[  OK  ] Алкотестер обнаружен."
else
    echo "[ FAIL ] Алкотестер НЕ НАЙДЕН!"
fi

if lsusb | grep -q 10c4:ea60; then
    echo "[  OK  ] Термометр обнаружен."
else
    echo "[ FAIL ] Термометр НЕ НАЙДЕН!"
fi



# > TEST printer device
# ls /dev/usb/lp*
# Должно отобразиться единственное печатное устройтсво /dev/usb/lp0
if ls /dev/usb/lp*; then
    echo "[  OK  ] Принтер обнаружен."
else
    echo "[ WARN ] Принтер НЕ НАЙДЕН!"
fi


# тест шлейфовой камеры
# DISPLAY=:0 rpicam-hello -t 0
DISPLAY=:0 rpicam-hello -t 0 --rotation 180