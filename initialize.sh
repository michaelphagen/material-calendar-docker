#!/bin/sh
echo "Creating Database"
mysql -uroot -ppassword -e "DROP DATABASE IF EXISTS booking"
mysql -uroot -ppassword -e "CREATE DATABASE booking"
mysql -uroot -ppassword booking < /var/www/nodejs/material-calendar-api/sql/material_calendar.sql
mysql -uroot -ppassword -e 'insert into user (user_id, password, first_name, last_name, email, user_type) values ("mph354","password","michael","hagen","mph354@nyu.edu",1)' booking
