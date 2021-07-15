#!/bin/sh

# Install node packages for front and backend
echo "Installing Frontend Dependencies"
yarn --cwd /var/www/nodejs/material-calendar
echo "Installing Backend Dependencies"
yarn --cwd /var/www/nodejs/material-calendar-api

# Start mysql-server, start the front end, and wait 15 seconds then start the backend
echo "Starting the Booking-App"
{ mysqld_safe & npm --prefix /var/www/nodejs/material-calendar run start & hostname > /var/haraka/config/me && haraka -c /var/haraka & sleep 15 && npm --prefix /var/www/nodejs/material-calendar-api run watch; }
