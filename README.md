Mosquitto
=========

Docker build file for mosquitto + auth-plugin. This docker file is based on
ubuntu 14.4 and mosquitto version 1.4.x. It will build Mosquitto from source
and also build the Mosquitto auth-plugin from source as found on:
https://github.com/jpmens/mosquitto-auth-plug.git

The only enabled auth backend currently is the MySQL backend

Build from scratch
======
git clone https://github.com/maxheadroom/Mosquitto.git
cd Mosquitto
docker build -t <yourname>/mosquitto .

Run it
======
sudo docker run -p 1883:1883 --name mosquitto -d <yourname>/mosquitto
