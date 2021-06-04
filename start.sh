#!/bin/sh
yarn --cwd /var/www/nodejs/material-calendar
yarn --cwd /var/www/nodejs/material-calendar-api
{ mysqld_safe & npm --prefix /var/www/nodejs/material-calendar run start & sleep 15 && /initialize.sh && npm --prefix /var/www/nodejs/material-calendar-api run watch; }
