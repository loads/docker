FROM stackbrew/debian:wheezy
MAINTAINER Mozilla Cloud Services

RUN echo "deb http://ftp.debian.org/debian sid main" >> /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y python3-pip
RUN apt-get install -y python-virtualenv
RUN apt-get install -y git
RUN apt-get install -y wget
RUN apt-get install -y python3-dev

# sshd
RUN apt-get -y install openssh-server
RUN mkdir /var/run/sshd
RUN sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config

# Adding loads user
RUN adduser --system loads
RUN mkdir -p /home/loads/.ssh
RUN sed -i s#/home/loads:/bin/false#/home/loads:/bin/bash# /etc/passwd

# Clearing and setting authorized ssh keys
RUN echo '' > /home/loads/.ssh/authorized_keys
RUN echo 'ssh-dss AAAAB3NzaC1kc3MAAACBAO1ruCNM0UDWugGQtsmO3B+LGJ+LxXVmQWo+53fOD+m8vQy98wFVpTTUWFXTXKUpAUkhgUOTuabIYSkEnpiDF9MasPFFwVHh9SNq1lWLifmPrHVGZ3+P5t6zskD51HaxeOuJJDasTIMxq8+d0TUP6SoGIzOWWU/GTVooqXsZ2/WnAAAAFQDdWZgnOsQm7FQWWYMSsP7LXXNrPwAAAIBRDreK4rnfeZU4oeLrnvMlakdzjAgCso7utwgZva95i7qjDHQODpWos+hjjLf6naRraXGnd2FVkep10luWzKiQpC4Hdy5s91203ZBZy/fw8coubNgt1Smd+Zi89yTLEe+xUYrSVoxfARY/e0DdRJmBb1ifkooAyujdTEhXmUDNLAAAAIBNUiOOL0s0m5Nth+fihLX7vwcexMCFS4PfnoERlAxj2tCWiNl8IEFbfYyiNMGVk9pjTnABpyaVCcNS8KopnPosvYwnSgpPUvZn7ssRacXwMF7PYd8h7iDN33jcmxGPLfnLwz+f6ODwvjIQOzAsPeNPh7d15NOVI6p/3O8LlgV+Jw== tarek@foobook.local' >> /home/loads/.ssh/authorized_keys

# set the default user to loads
#USER loads

# deploying the loads-broker project
RUN git clone https://github.com/loads/loads-broker /home/loads/loads-broker
RUN cd /home/loads/loads-broker; make build

EXPOSE 22
EXPOSE 8080
EXPOSE 8083
EXPOSE 8086
EXPOSE 8084

ADD boto.cfg /etc/boto.cfg

CMD /home/loads/loads-broker/bin/loads-broker
