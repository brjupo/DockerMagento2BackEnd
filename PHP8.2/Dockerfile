# https://medium.com/swlh/alpine-slim-stretch-buster-jessie-bullseye-bookworm-what-are-the-differences-in-docker-62171ed4531d
FROM php:8.2-fpm-buster
MAINTAINER "brjupo"
# ------------------------- TO DO -------------------------
# Intall systemctl
# Variable for xdebug IP
# Improve php-fpm https://www.php.net/manual/en/install.fpm.configuration.php
# ---------- Session Lifetime ---------
# In php.ini file, change the following:
#
# session.cookie_lifetime 31536000
# session.gc_maxlifetime 31536000

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
# Check in your phpinfo(); if some of this libraries are installed
# Over each docker-php-ext-install line, will be a apt-get line in case of something missing
# https://github.com/docker-library/php/blob/master/docker-php-ext-install
# https://experienceleague.adobe.com/docs/commerce-operations/installation-guide/system-requirements.html
RUN apt-get install libcurl4-openssl-dev
RUN apt-get install libxml2-dev -y
RUN docker-php-ext-install bcmath ctype curl dom
# https://stackoverflow.com/a/62449355
RUN apt-get install zlib1g-dev libpng-dev libjpeg-dev -y

# Wolf + https://magento.stackexchange.com/a/334687/93150
RUN apt-get install -y libjpeg62-turbo-dev libsodium-dev libfreetype6-dev

RUN docker-php-ext-configure gd --with-jpeg --with-freetype
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
# https://experienceleague.adobe.com/docs/commerce-operations/installation-guide/system-requirements.html [For compatibility with 2.1, 2.2 & 2.5]
# https://getcomposer.org/download/
# https://magento.stackexchange.com/questions/360583/class-magento-framework-component-componentregistrar-not-found-in-setup-src-ma
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.2.18

# ------------------------- XDEBUG -------------------------
# https://xdebug.org/docs/compat
# https://xdebug.org/download/historical
# Xdebug: [Config] The setting 'xdebug.remote_enable' has been renamed, see the upgrading guide at https://xdebug.org/docs/upgrade_guide#changed-xdebug.remote_enable (See: https://xdebug.org/docs/errors#CFG-C-CHANGED)
RUN pecl install xdebug-3.2.2 \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request=trigger" >> /usr/local/etc/php/conf.d/xdebug.ini

    # This option DOES NOT WORK and causes de WARNING:
    # Xdebug: [Step Debug] Could not connect to debugging client. Tried: 172.17.0.1:9000 (through xdebug.client_host/xdebug.client_port) :-(
    # && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
    # && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/xdebug.ini

    # Works, but the WARNING message always appers in console
    # && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    # && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

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
