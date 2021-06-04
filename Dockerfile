From node:latest

RUN apt update && apt install dirmngr lsb-release yarn nginx -y
RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 5072E1F5
RUN echo "deb http://repo.mysql.com/apt/debian $(lsb_release -sc) mysql-8.0" | \
	tee /etc/apt/sources.list.d/mysql80.list
RUN apt update
#RUN mkdir /etc/mysql

RUN echo "mysql-community-server mysql-community-server/root-pass password password" | debconf-set-selections

RUN echo "mysql-community-server mysql-community-server/re-root-pass password password" | debconf-set-selections

RUN echo "mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)" | debconf-set-selections

RUN DEBIAN_FRONTEND=noninteractive apt install -y mysql-server

RUN { mysqld_safe & sleep 10 && mysql -uroot -ppassword -e 'ALTER USER "root"@"localhost" IDENTIFIED WITH mysql_native_password BY "password"' && kill -9 mysqld; } ; exit 0

RUN mkdir -p /var/www/nodejs && cd /var/www/nodejs && git clone https://github.com/dwmorrin/material-calendar.git && git clone https://github.com/dwmorrin/material-calendar-api

RUN echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p ; exit 0

RUN cat /etc/nginx/sites-enabled/default
COPY start.sh /start.sh
COPY initialize.sh /initialize.sh

RUN rm /etc/nginx/sites-enabled/*

COPY my.cnf /etc/mysql

#COPY proxy.conf /etc/nginx/sites-enabled/

EXPOSE 80/tcp 80/udp 443/tcp 443/udp 3000/tcp 3000/udp 3306/tcp 3306/udp
#ENV CHOKIDAR_USEPOLLING="true"
CMD /start.sh
