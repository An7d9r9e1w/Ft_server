FROM	debian:buster

EXPOSE	80
EXPOSE	443

ENV 	WPDIR=/var/www/wordpress
ENV		PHPDIR=$WPDIR/phpmyadmin
ENV		NGINXDIR=/etc/nginx/
ENV		SSLDIR=/etc/ssl/
ENV		LOCAL=/usr/local/

RUN		apt-get update && apt-get install -y \
		nginx			\
		mariadb-server	\
		php				\
		php-fpm			\
		php-mysql		\
		php-common		\
		php-cli			\
		php-json		\
		php-opcache		\
		php-readline	\
		php-mbstring	\
		php-xml			\
		php-gd			\
		php-curl		\
		php-xmlrpc		\
		php-soap		\
		php-intl		\
		php-zip			\
		curl			\
		vim

WORKDIR	tmp
RUN		curl -OL https://wordpress.org/latest.tar.gz
RUN		tar -xf latest.tar.gz
RUN		mv wordpress $WPDIR
#RUN		ls $WPDIR && sleep 10
RUN		curl -OL \
		https://files.phpmyadmin.net/phpMyAdmin/4.9.7/phpMyAdmin-4.9.7-english.tar.gz
RUN		tar -xf phpMyAdmin-4.9.7-english.tar.gz
RUN		mv phpMyAdmin-4.9.7-english $PHPDIR
RUN		rm -f ./*

WORKDIR	$WPDIR
RUN		mv wp-config-sample.php wp-config.php
RUN		sed -i.tmp -e 's/database_name_here/wordpress_db/g; s/username_here/wordpress_user/g; s/password_here/password/g' wp-config.php && rm wp-config.php.tmp
RUN		chown -R www-data:www-data ./
RUN		chmod -R 755 ./

WORKDIR	$NGINXDIR
RUN		rm -f sites-available/default && rm -f sites-enabled/default
#COPY	srcs/nginx.conf sites-available/
#RUN		ln -s sites-available/nginx.conf sites-enabled/
COPY	srcs/nginx.conf sites-available/
RUN		ln -s $NGINXDIR/sites-available/nginx.conf $NGINXDIR/sites-enabled/

WORKDIR	$SSLDIR
RUN		openssl genrsa -out certkey.key 4096
RUN		openssl req -x509 -new -key certkey.key -days 365 -out cert.crt \
		-subj "/C=US/ST=San Andreas/L=Los Santos/O=Grove Street Families/OU=LS/CN=wordpress"

WORKDIR	$LOCAL
COPY	srcs/script.sh ./
COPY	srcs/autoindex.sh ./
COPY	srcs/wordpress.sql ./
RUN		chmod 755 script.sh
RUN		chmod 755 autoindex.sh

CMD		["bash", "script.sh"]
