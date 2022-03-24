#!/bin/bash

#Абсолютный путь до peervpn
peervpn=/home/momai/peervpn

#Абсолютный путь до данного скрипта
deb=/home/momai/updatepeervpn

#Определяем минорную версию исходников
export ver=$(grep "PEERVPN_VERSION_MINOR" globals.ic | awk -F " " '{print $3}')

#Определяем минорную версию для сборки deb
export repover=$(grep "Version: " $deb/package/DEBIAN/control |  awk -F "0" '{print $3}')

if [ $repover -eq $ver ]; then

##если версии равны, то не выполняем
echo -e "\033[37;1;41m  установлена актуальная версия в репозиторий test2 \033[0m"

else

#заменяем номер весии на тот, что нашел в сырцах :)
sed -i "s/$repover/$ver/" $deb/package/DEBIAN/control

# компилируем проект
make
make install

#переносим собранное приложение в среду для сборки deb
mv peervpn $deb/package/usr/local/bin/

#собираем deb
dpkg-deb --build $deb/package mypeervpn.deb


fi
