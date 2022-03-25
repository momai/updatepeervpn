# updatepeervpn
Скрипт позволяет настроить repo на сервере Ubuntu с использованием ansible и bash.

### Подготовка
Подготовить машину с установленным ansible, лучше взять Ubuntu.
Выкачать этот репозиторий.

Сервер где будет раскатан репозиторий и компил должен соответсвовать следующим требованиям:
- Платформа Ubuntu
- Пользователь, не root, по которому будет осуществляться подключение.

Внести следующшие изменения:


1) В файл **hosts** внести действующие **IP** адреса repo серверов

2) В файл  **install.sh** указать **user** по которому будет осуществляться подключение и ИП адреса конечных машин.

3) В файл **bootstrap.yml** так же внести имя пользователя в строке **remote_user:**

4) В файл **apache.yml** внести **remote_user:**



### Использование:
запустить ./install.sh прописать пароль от пользователя столько раз, сколько попросит. Будет добавлен ключ для ssh доступа, а так же внесены изменения в sudoers для доступа к sudo без пароля.
Затем запустить плейбук командой:

**ansible-playbook -i hosts -l repo apache.yml**

Дождаться выполнения.
После завершения, на машинах клиентов добавить репозиторий
> deb [trusted=yes] http://HOSTNAME/ bionic main

**Что бы обновить пакет необходимо внести изменения в репозиторий peervpn, что бы публиковалась новая версия приложения.**
Если такой возможности нет, но очень хочется опубликовать пакет повторно, необходимо подключиться к серверу репозитория и руками внести изменения в файл peervpn/globals.ic повысить цифру в define PEERVPN_VERSION_MINOR 44. И затем уже можно запускать перекомпил по команде ниже.


**ssh momai@192.168.1.44 bash /opt/src/updatepeervpn/update.sh**

Задание можно поставить в cron.


### Замечания:
* Скрипт осуществляет проверку версии на основе данных исходников из файла globals.ic и того, что прописано в control. Других вариантов определения версии для peervpn я не нашёл. В случае, если версии совпадают, скрипт не выполняется. Если версии отличаются - в файл package/DEBIAN/control скрипт прописывает актуальную версию из globals.ic
* Для подключения репозитория на клиентах, в sources.list необходимо прописать 
> deb [trusted=yes] http://HOSTNAME/ bionic main

* Версионную проверку можно было бы организовать через наличие изменений в репозитории peervpn, однако в нём очень давно ничего не делалось, потому, предполагая, что если и будут вноситься изменения в данный пакет, то делаться это будет либо локально, либо в форках, потому проверку версии осуществлял именно локально на основе исходников.
