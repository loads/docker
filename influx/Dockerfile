FROM stackbrew/debian:wheezy
MAINTAINER Mozilla Cloud Service

RUN echo "deb http://ftp.debian.org/debian sid main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y curl

# influxdb
RUN curl http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb > influxdb_latest_amd64.deb
RUN dpkg -i influxdb_latest_amd64.deb
RUN apt-get update

EXPOSE 8083
EXPOSE 8086
EXPOSE 8084

ADD config.toml /config/config.toml
ADD run.sh /run.sh
RUN chmod +x /*.sh


CMD /run.sh
