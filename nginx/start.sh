#!/bin/bash

# Set custom webroot
if [ ! -z "$WEBROOT" ]; then
 sed -i "s#root /var/www/html;#root ${WEBROOT};#g" /etc/nginx/conf.d/default.conf
fi

# Set php.ini
if [ ! -z "$SET_PHP_INI_ENV" ]; then
	if [ -f "/usr/local/etc/php/php.ini-${SET_PHP_INI_ENV}" ]; then
		cp -f "/usr/local/etc/php/php.ini-${SET_PHP_INI_ENV}" /usr/local/etc/php/php.ini
    fi
fi

# Manage php opcache
if [ ! -z "$CACHE" ]; then
  echo "opcache.enable=$CACHE" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
fi

if [ ! -z "$TIMEZONE" ]; then
	echo $TIMEZONE > /etc/TZ
fi

# Set the desired timezone
echo date.timezone=$(cat /etc/TZ) > /usr/local/etc/php/conf.d/timezone.ini

# Increase the memory_limit
if [ ! -z "$PHP_MEM_LIMIT" ]; then
 sed -i "s/memory_limit = 2048M/memory_limit = ${PHP_MEM_LIMIT}M/g" /usr/local/etc/php/conf.d/docker-vars.ini
fi

# Increase the post_max_size
if [ ! -z "$PHP_POST_MAX_SIZE" ]; then
 sed -i "s/post_max_size = 100M/post_max_size = ${PHP_POST_MAX_SIZE}M/g" /usr/local/etc/php/conf.d/docker-vars.ini
fi

# Increase the upload_max_filesize
if [ ! -z "$PHP_UPLOAD_MAX_FILESIZE" ]; then
 sed -i "s/upload_max_filesize = 100M/upload_max_filesize= ${PHP_UPLOAD_MAX_FILESIZE}M/g" /usr/local/etc/php/conf.d/docker-vars.ini
fi

# Start supervisord and services
exec /usr/bin/supervisord -n -c /etc/supervisord.conf
