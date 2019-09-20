FROM ubuntu:xenial
MAINTAINER leifj@sunet.se
RUN apt-get -y update
RUN apt-get install -y pound ssl-cert
ADD pound_2.6-3~sunet1_amd64.deb /pound_2.6-3~sunet1_amd64.deb
RUN dpkg -i /pound_2.6-3~sunet1_amd64.deb
ADD start.sh /start.sh
RUN chmod a+rx /start.sh
VOLUME /etc/ssl
ENTRYPOINT ["/start.sh"]
EXPOSE 443
EXPOSE 80
