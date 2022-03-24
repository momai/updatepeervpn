#!/bin/bash

#Абсолютный путь до peervpn
peervpn=/home/momai/peervpn

#Абсолютный путь до данного скрипта
deb=/home/momai/updatepeervpn

#deb=echo pwd
#echo $deb
cd $peervpn

#ls $deb/package/
#Проверяем обновления.
git pull https://github.com/peervpn/peervpn.git

#dir = /home/momai/peervpn
#Определяем минорную версию исходников
export ver=$(grep "PEERVPN_VERSION_MINOR" globals.ic | awk -F " " '{print $3}')

#Определяем минорную версию для сборки deb
export repover=$(grep "Version: " $deb/package/DEBIAN/control |  awk -F "0" '{print $3}')

if [ $repover -eq $ver ]; then

##если версии равны, то не выполняем
echo -e "\033[37;1;41m  установлена актуальная версия в репозиторий test2 \033[0m"

else

##если версии отличаются, то выполняем обновление
echo -e "\033[37;1;41m  версия пакета в репозитории отличается от исходников. \033[0m"
echo -e "\033[37;1;41m   Версия в репозитории: $repover. \033[0m"
echo -e "\033[37;1;41m   Версия в исходниках: $ver. \033[0m"
echo -e "\033[37;1;41m   Запуск обновления. \033[0m"

#заменяем номер весии на тот, что нашел в сырцах :)
sed -i "s/$repover/$ver/" $deb/package/DEBIAN/control

# устанавливаем необходимые для компиляции зависимости
# apt-get install libssl1.0-dev build-essential zlib1g-dev

# компилируем проект
make
make install

#переносим собранное приложение в среду для сборки deb
mv peervpn $deb/package/usr/local/bin/

#собираем deb
dpkg-deb --build $deb/package mypeervpn.deb

#публикуем
#aptly repo add test2 mypeervpn.deb
#aptly publish update -skip-signing test2


fi
