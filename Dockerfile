From node:latest

# Install Prerecs
RUN apt update && apt install dirmngr lsb-release yarn -y

# Add mysql repo for this distro
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5072E1F5
RUN echo "deb http://repo.mysql.com/apt/debian $(lsb_release -sc) mysql-8.0" | \
	tee /etc/apt/sources.list.d/mysql80.list
RUN apt update

# Populate debconf-set-selections with required answers to make mysql install non-interactive
RUN echo "mysql-community-server mysql-community-server/root-pass password password" | debconf-set-selections
RUN echo "mysql-community-server mysql-community-server/re-root-pass password password" | debconf-set-selections
RUN echo "mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)" | debconf-set-selections

# Install mysql-server non-interactive
RUN DEBIAN_FRONTEND=noninteractive apt install -y mysql-server

# Pre Clone in repos
RUN mkdir -p /var/www/nodejs && cd /var/www/nodejs && git clone https://github.com/dwmorrin/material-calendar.git && git clone https://github.com/dwmorrin/material-calendar-api

# Set up mysql database
RUN { mysqld_safe & sleep 10 && mysql -uroot -ppassword -e 'ALTER USER "root"@"localhost" IDENTIFIED WITH mysql_native_password BY "password"' && mysql -uroot -ppassword -e 'UPDATE mysql.user SET host="%" WHERE user="root" AND host="localhost"' && mysql -uroot -ppassword -e 'FLUSH PRIVILEGES' && pkill mysqld; } ; exit 0

# Copy over database startup stuff
COPY startup.sql /var/sql/
COPY material_calendar.sql /var/sql

# Change Working Directory to /var/sql
WORKDIR /var/sql

# Set up mysql database
RUN { mysqld_safe & sleep 10 && mysql -uroot -ppassword < /var/sql/startup.sql && pkill mysqld; } ; exit 0


# Set higher maximum watchers for hot reloads
RUN echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p ; exit 0

# Install Haraka for emailing
RUN npm install -g Haraka

# Copy over start script and mysql config
COPY start.sh /start.sh
COPY my.cnf /etc/mysql
COPY haraka/ /var/haraka

# Expose Port 3000 for webapp
EXPOSE 3000/tcp 3306/tcp

# Run command is the start script
CMD /start.sh
