#!/bin/bash
if grep 'autoindex off;' /etc/nginx/sites-available/nginx.conf; then
	sed -i.tmp -e 's/autoindex off;/autoindex on;/g; s/#index no_files_no_lifes/index no_files_no_lifes/g' /etc/nginx/sites-available/nginx.conf
else
	sed -i.tmp -e 's/autoindex on;/autoindex off;/g; s/index no_files_no_lifes/#index no_files_no_lifes/g' /etc/nginx/sites-available/nginx.conf
fi
rm -f /etc/nginx/sites-available/nginx.conf.tmp
service nginx reload
