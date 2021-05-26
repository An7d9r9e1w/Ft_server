#!/bin/bash

service mysql start && \
mariadb -e "CREATE DATABASE wordpress_db DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci"
mariadb -e "GRANT ALL ON wordpress_db.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'password'"
mariadb -e "FLUSH PRIVILEGES"
mariadb wordpress_db < wordpress.sql

service php7.3-fpm start && \
service nginx start && \

while true; do
	sleep 1
done
