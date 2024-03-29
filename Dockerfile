From node:16-bullseye

# Install Prerecs
RUN apt update && apt install dirmngr lsb-release yarn python -y

# Populate debconf-set-selections with required answers to make mysql install non-interactive
RUN echo "mariadb-server mariadb-server/root-pass password password" | debconf-set-selections
RUN echo "mariadb-server mariadb-server/re-root-pass password password" | debconf-set-selections
RUN echo "mariadb-server mariadb-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)" | debconf-set-selections

# Install mysql-server non-interactive
RUN DEBIAN_FRONTEND=noninteractive apt install -y mariadb-server

# Pre Clone in repos
RUN mkdir -p /var/www/nodejs && cd /var/www/nodejs && git clone https://github.com/dwmorrin/material-calendar.git && git clone https://github.com/dwmorrin/material-calendar-api

# Set up mysql database
RUN { mysqld_safe & sleep 10 && mysql -uroot -ppassword -e 'ALTER USER "root"@"localhost" IDENTIFIED BY "password"' && pkill mysqld; }
RUN { mysqld_safe & sleep 10 && mysql -uroot -ppassword -e 'RENAME USER "root"@"localhost" TO "root"@"%"' && pkill mysqld; }
RUN { mysqld_safe & sleep 10 && mysql -uroot -ppassword -e 'FLUSH PRIVILEGES' && pkill mysqld; }
# Copy over .env file for backend
COPY backend.env /var/www/nodejs/material-calendar-api/.env

# Change working directory to api for database setup
WORKDIR /var/www/nodejs/material-calendar-api/

# Install Backend Dependencies for Database setup
RUN yarn

# Set up mysql database
RUN { mysqld_safe & sleep 10 && node /var/www/nodejs/material-calendar-api/startup.mjs && pkill mysqld; }

# Set higher maximum watchers for hot reloads
RUN echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p ; exit 0

# Install Haraka for emailing
RUN npm install -g npm
RUN npm install -g Haraka

# Copy over start script and mysql config
COPY start.sh /start.sh
COPY my.cnf /etc/mysql
COPY haraka/ /var/haraka

# Expose Port 3000 for webapp
EXPOSE 3000/tcp 3306/tcp

# Run command is the start script
CMD /start.sh
