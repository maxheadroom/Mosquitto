FROM ubuntu:latest

MAINTAINER Falko Zurell <falko.zurell@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install wget \
  git \
  build-essential \
  libwrap0-dev \
  libssl-dev \
  python-distutils-extra \
  libc-ares-dev \
  mosquitto-clients \
  uuid-dev \
  libmysqlclient-dev -y
RUN mkdir -p /usr/local/src
WORKDIR /usr/local/src
RUN wget http://mosquitto.org/files/source/mosquitto-1.4.2.tar.gz && tar xvzf ./mosquitto-1.4.2.tar.gz
WORKDIR /usr/local/src/mosquitto-1.4.2
RUN make && make install
# copy example config file

WORKDIR /usr/local/src/
# use owntracks tools to generate the necessary SSL certificates
RUN git clone https://github.com/owntracks/tools.git owntracks
WORKDIR /usr/local/src/owntracks
RUN ./mosquitto-setup.sh
# build mosquitto authentication plugin
WORKDIR /usr/local/src/
# fetch auth-plug sources
RUN git clone https://github.com/jpmens/mosquitto-auth-plug.git
# fetch config patches
RUN git clone https://github.com/maxheadroom/Mosquitto.git
WORKDIR /usr/local/src/mosquitto-auth-plug
RUN cp config.mk.in config.mk
RUN patch -i /usr/local/src/Mosquitto/patches/config.mk.in.patch -o config.mk config.mk.in
RUN make && cp auth-plug.so /usr/local/lib

RUN ldconfig
# create runtime user for mosquitto
RUN adduser --system --disabled-password --disabled-login mosquitto
EXPOSE 1883
CMD ["/usr/local/sbin/mosquitto"]
