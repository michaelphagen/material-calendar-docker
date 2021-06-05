#!/bin/sh

# Install node packages for front and backend
yarn --cwd /var/www/nodejs/material-calendar
yarn --cwd /var/www/nodejs/material-calendar-api

# Start mysql-server, start the front end, and wait 15 seconds then start the backend
{ mysqld_safe & npm --prefix /var/www/nodejs/material-calendar run start & sleep 15 && npm --prefix /var/www/nodejs/material-calendar-api run watch; }
