Visual Studio Code Default Markdown Preview Shortcut 
```
CTRL+K V
```
<br>
<br>

# How to install Adobe Commerce [Magento 2.x] in LOCAL using THESE Dockers

https://experienceleague.adobe.com/docs/commerce-operations/installation-guide/composer.html?lang=en

### Magento Open Source Edition / Community Edition CE
```shell
composer global config http-basic.repo.magento.com <public_key/username> <private_key/password>

composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.0 ./
```

### Magento Commerce / Enterprise Edition EE
For this EE you MUST have keys, first you need to add keys and then create the composer project
https://stackoverflow.com/questions/76779035/magento-2-fresh-install

```shell
composer global config http-basic.repo.magento.com <public_key/username> <private_key/password>

composer create-project --repository-url=https://repo.magento.com/ magento/project-enterprise-edition=2.4.0 ./
```



## Change permissions

For Docker Debian  
PRETTY_NAME="Debian GNU/Linux 10 (buster)"
https://unix.stackexchange.com/a/182225

```shell
## AS ROOT got to installation root folder
cd /var/www/html/<magento_install_directory>

# Change permissions for files 
find var generated pub/static pub/media app/etc -type f -exec chmod g+w {} \;
# This can take time, vendor folder contains 6,000 files
find vendor -type f -exec chmod g+w {} \;

# Change permissions for directories 
find var generated pub/static pub/media app/etc -type d -exec chmod g+ws {} \;
# This can take time, vendor folder contains hundreds of directories
find vendor -type d -exec chmod g+ws {} \;

# Change owner
chown -R magento2:magento2 . 

## AS magento2 user
chmod u+x bin/magento
```

## Create the database  

Connect to localhost:3306 or mysqldb:3306 or [docker-ip]:3306
```shell
mysql -u root -p -h 172.17.0.1
```
```sql
CREATE DATABASE php74mine;
```

## Install the application

### For Magento < 2.4.7

Run install command

```bash
bin/magento setup:install \
--base-url=http://php74mine.local \
--db-host=172.17.0.1 \
--db-name=php74mine \
--db-user=root \
--db-password=mysql \
--admin-firstname=UserFirstName \
--admin-lastname=UserLastName \
--admin-email=my@mail.com \
--admin-user=adminUser \
--admin-password=Admi123q \
--language=es_MX \
--currency=MXN \
--timezone=America/Mexico_City \
--use-rewrites=1 \
--search-engine=elasticsearch7 \
--elasticsearch-host=elasticsearch7 \
--elasticsearch-port=9200 \
--elasticsearch-index-prefix=php74_mine \
--elasticsearch-timeout=15
```

### For Magento >= 2.4.7

Add this configuration to app/etc/env.php

````php
<?php
return [
    'system' => [
        'default' => [
            'catalog' => [
                'search' => [
                    'engine' => 'opensearch',
                    'opensearch_server_hostname' => '172.17.0.2',   // Could be docker gateway IP
                    'opensearch_server_port' => 10200,              // Port assigned to opensearch
                    'opensearch_index_prefix' => 'op_project_'      // Recommended prefix
                ]
            ]
        ]
    ]
];
````

Run install command

```
bin/magento setup:install \
--base-url=http://php74mine.local \
--db-host=172.17.0.1 \
--db-name=php74mine \
--db-user=root \
--db-password=mysql \
--admin-firstname=UserFirstName \
--admin-lastname=UserLastName \
--admin-email=my@mail.com \
--admin-user=adminUser \
--admin-password=Admi123q \
--language=es_MX \
--currency=MXN \
--timezone=America/Mexico_City \
--use-rewrites=1
```

## Add secure permissions
At the end of installation
https://experienceleague.adobe.com/docs/commerce-operations/configuration-guide/deployment/file-system-permissions.html?lang=en
```
For security, remove write permissions from these directories: '/var/www/html/app/etc'
```

## Edit app/etc/env.php file

1. Change Admin route to /admin  
2. Change MAGE_MODE from default to developer



## Uninstall Two Factor Auth

### For Magento < 2.4.5

```shell
php bin/magento module:disable Magento_TwoFactorAuth
```

### For Magento >= 2.4.5

```shell
php bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth Magento_TwoFactorAuth
```

## Install Sample Data

https://experienceleague.adobe.com/docs/commerce-operations/installation-guide/next-steps/sample-data/composer-packages.html?lang=en  

```shell
php bin/magento sampledata:deploy
php bin/magento setup:upgrade
```



## Set in NGINX the docker-ip at vhost.conf

````conf
upstream php74mine.local { server 172.17.0.2:8060; }
server {
  listen 80;
  server_name php74mine.local;
  access_log /var/log/nginx/php74mine.local;
  error_log /var/log/nginx/php74mine.local;
  location / {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $http_host;
    proxy_set_header X-Nginx-Proxy true;
    proxy_pass http://php74mine.local;
    proxy_redirect off;
    proxy_connect_timeout 600;
    proxy_send_timeout 600;
    proxy_read_timeout 600;
    proxy_buffer_size 128k;
    proxy_buffers 4 256k;
    proxy_busy_buffers_size 256k;
  }
}
````



## Set in /etc/hosts

    127.0.0.1 	php74mine.local

## Test site
In browser open http://php74mine.local

If something wrong, try the first "dev compilation"

```shell
rm -rf ./generated/* ./var/view_preprocessed/* ./var/cache/* ./var/page_cache/* ./var/session/* ./pub/static/*/*
# php bin/magento deploy:mode:show
php bin/magento setup:upgrade
# php bin/magento setup:di:compile
php bin/magento cache:flush
php bin/magento dev:source-theme:deploy
# git branch
date
```

If test was succesful continue to the next step, otherwise, verify the installation and fix it

## Create a different admin user

```shell
php bin/magento admin:user:create --admin-user=DifferentUser --admin-password=Admi123q --admin-email=dif_user@gmail.com --admin-firstname=UserFirstname	 --admin-lastname=UserLastname
```

## Test admin
Go to http://php74mine.local/admin and log with your user