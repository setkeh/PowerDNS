# This was largely copied from zfjagann/powerdns
FROM ubuntu:14.04
MAINTAINER James Griffis <setkeh@gmail.com>

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Fix locales
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Enable universe
RUN echo "deb http://archive.ubuntu.com/ubuntu precise universe" >> /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PowerDNS
RUN echo "START=no" > /etc/default/pdns && apt-get update && apt-get install pdns-server pdns-backend-mysql -y && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD /usr/sbin/pdns_server \
	--no-config \
	--master \
	--daemon=no \
	--local-address=0.0.0.0 \
	--allow-axfr-ips=0.0.0.0/0 \
	--launch=gmysql \
	--gmysql-host=$DB_PORT_3306_TCP_ADDR \
	--gmysql-port=$DB_PORT_3306_TCP_PORT \
	--gmysql-user=${DB_ENV_USER:-pdns} \
	--gmysql-password=${DB_ENV_USER:-pdns} \
	--gmysql-dbname=${DB_ENV_DB:-pdns} \
	--webserver \
	--webserver-address=0.0.0.0 \
	--webserver-port=8053 \
	--webserver-password=$WEBPASSWD
EXPOSE 53 8053
