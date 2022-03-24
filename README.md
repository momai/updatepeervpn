# updatepeervpn
Скрипт для создания deb пакета peervpn и его публикации в свой репозиторий.

### Подготовка

Перед использованием необходимо:
* Установить утилиту aptly предназначенную для работы с репозиториями:

> apt-get install aptly

* Перенести конфиг
> mv /root/.aptly.conf /etc/aptly.conf

* Прописать в нём путь
> "rootDir": "/opt/aptly",

* Создать репозиторий test2:

> aptly repo create -distribution="bionic" test2

* Опубликовать репозиторий:

> aptly publish repo -skip-signing=true test2
> 
* Полученный репозиторий опубликовать в web
Можно создать отдельный, или заменить существующий файл /etc/apache2/sites-available/000-default.conf

><VirtualHost *:80>
>
>ServerName repo.lab
>
>ServerAdmin webmaster@localhost
>
>DocumentRoot /opt/aptly/public
>
>ErrorLog ${APACHE_LOG_DIR}/aptly_error.log
>
>CustomLog ${APACHE_LOG_DIR}/aptly_access.log combined
>
>    <Directory /opt/aptly/public>
>    
>  Options +Indexes +FollowSymLinks +MultiViews
>       
>  AllowOverride All
>       
>  Require all granted
>       
> </Directory>
>    
></VirtualHost>
 
 
### Использование:

* Выкачать исходники peervpn (https://github.com/peervpn/peervpn.git)

* Указать переменные в update.sh
 
Абсолютный путь до peervpn
> peervpn=/home/momai/peervpn

Абсолютный путь до данного скрипта
> deb=/home/momai/updatepeervpn

* Публикация в репозиторий осуществляется внутри скрипта командой aptly repo add test2 mypeervpn.deb

### Замечания:
* Скрипт осуществляет проверку версии на основе данных исходников из файла globals.ic и того, что прописано в control. Других вариантов определения версии для peervpn я не нашёл. В случае, если версии совпадают, скрипт не выполняется. Если версии отличаются - в файл package/DEBIAN/control скрипт прописывает актуальную версию из globals.ic
* Для подключения репозитория на клиентах, в sources.list необходимо прописать 
> deb [trusted=yes] http://HOSTNAME/public bionic main

* Версионную проверку можно было бы организовать через наличие изменений в репозитории peervpn, однако в нём очень давно ничего не делалось, потому, предполагая, что если и будут вноситься изменения в данный пакет, то делаться это будет либо локально, либо в форках, потому проверку версии осуществлял именно локально на основе исходников.
