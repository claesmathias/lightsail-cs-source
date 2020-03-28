FROM ubuntu:18.04
MAINTAINER Mathias Claes

# define default env variables
ENV MAP de_dust2
ENV MAXPLAYERS 16

# install dependencies
RUN apt-get update && \
    apt-get -qqy install lib32gcc1 curl

# create directories
WORKDIR /root
RUN mkdir Steam .steam

# download steamcmd
WORKDIR /root/Steam
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# install CS Source via steamcmd
RUN ./steamcmd.sh +login anonymous +force_install_dir /css +app_update 232330 validate +quit

# start server
WORKDIR /css
ENTRYPOINT ./srcds_run -game cstrike -secure +maxplayers $MAXPLAYERS +map $MAP -port $PORT
