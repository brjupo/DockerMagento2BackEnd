# https://medium.com/swlh/alpine-slim-stretch-buster-jessie-bullseye-bookworm-what-are-the-differences-in-docker-62171ed4531d
FROM php:7.4-fpm-buster
MAINTAINER "brjupo"

# ------------------------- BASIC ONES -------------------------
# https://manpages.debian.org/stretch/apt/apt-get.8.en.html
RUN apt-get update && apt-get install -my wget gnupg

RUN apt-get update && apt-get install -y \
    apt-utils \
    sudo \
    wget \
    unzip \
    cron \
    curl \
    git \
    vim \
    nano

# ------------------------- MAGENTO 2 - PHP EXTENSIONS -------------------------
# https://github.com/docker-library/php/blob/master/docker-php-ext-install
# https://experienceleague.adobe.com/docs/commerce-operations/installation-guide/system-requirements.html
RUN apt-get install libcurl4-openssl-dev
RUN apt-get install libxml2-dev -y
RUN docker-php-ext-install bcmath ctype curl dom

RUN apt-get install zlib1g-dev libpng-dev -y
RUN docker-php-ext-install fileinfo filter gd
#https://github.com/docker-library/php/issues/1137
#/usr/local/lib/php/extensions/
# RUN docker-php-ext-install hash iconv
RUN docker-php-ext-install intl
# RUN docker-php-ext-install json libxml mbstring openssl pcre
RUN docker-php-ext-install pdo_mysql
# RUN docker-php-ext-install simplexml
RUN docker-php-ext-install soap sockets
# RUN docker-php-ext-install sodium spl tokenizer xmlwriter

RUN apt-get install libxslt-dev -y
RUN docker-php-ext-install xsl

RUN apt-get install libzip-dev -y
RUN docker-php-ext-install zip
# RUN docker-php-ext-install zlib
# RUN docker-php-lib-install libxml #Installed with pkg-config & libcurl4-openssl-dev

# ------------------------- COMPOSER -------------------------
# https://experienceleague.adobe.com/docs/commerce-operations/installation-guide/system-requirements.html
# https://getcomposer.org/download/
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.20

# ------------------------- XDEBUG -------------------------
# https://xdebug.org/docs/compat    https://xdebug.org/download/historical
RUN pecl install xdebug-3.1.5 \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# ------------------------- SUPERVISOR -------------------------
RUN apt-get install supervisor -y
ADD ./conf/supervisord.conf /etc/supervisord.conf

# ------------------------- APACHE2 -------------------------
RUN apt-get update && apt-get install -y apache2
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_fcgi
RUN rm -f /etc/apache2/sites-enabled/000-default.conf
# apache config
ADD ./conf/apache-default.conf /etc/apache2/sites-enabled/apache-default.conf
# Variables
ENV SHARED_CODE_PATH /var/www/html
ENV WEBROOT_PATH /var/www/html
ENV APACHE_PID_FILE='/run/apache2/apache2.pid'
ENV APACHE_RUN_USER=magento2
ENV APACHE_RUN_GROUP=magento2
ENV APACHE_RUN_DIR='/var/www/html/pub'
ENV APACHE_LOG_DIR='/var/log/apache2'

# ------------------------- PHP-FPM -------------------------
RUN rm -r /usr/local/etc/php-fpm.d/*
# PHP config
ADD ./conf/php.ini /usr/local/etc/php
# php-fpm config
ADD ./conf/php-fpm-magento2.conf /usr/local/etc/php-fpm.d/php-fpm-magento2.conf

# ------------------------- NEW USER magento2 -------------------------
RUN useradd -m -d /home/magento2 -s /bin/bash magento2 && adduser magento2 sudo
RUN chown -R magento2:magento2 /var/www/html
RUN sed -i 's/www-data/magento2/g' /etc/apache2/envvars
# Uncomment the next line for existing projects.
# chmod +x /var/www/html/bin/magento
ENV PHP_EXTRA_CONFIGURE_ARGS="--enable-fpm --with-fpm-user=magento2 --with-fpm-group=magento2"
# Delete user password to connect with ssh with empty password
RUN passwd magento2 -d

# ------------------------- NETSTAT -------------------------
# Debug services with netstat -a
RUN apt install net-tools -y
# localhost:9000 should be active to warranty that php-fpm is running

# ------------------------- ENTRYPOINT -------------------------
ADD ./conf/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80
WORKDIR /var/www/html

USER root

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]