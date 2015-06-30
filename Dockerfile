FROM ubuntu:latest

MAINTAINER Falko Zurell <falko.zurell@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install wget build-essential libwrap0-dev libssl-dev python-distutils-extra libc-ares-dev mosquitto-clients uuid-dev -y
RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src
RUN wget http://mosquitto.org/files/source/mosquitto-1.4.2.tar.gz
RUN tar xvzf ./mosquitto-1.4.2.tar.gz
WORKDIR /usr/local/src/mosquitto-1.4.2
RUN make
RUN make install
RUN adduser --system --disabled-password --disabled-login mosquitto
EXPOSE 1883
CMD ["/usr/local/sbin/mosquitto"]
