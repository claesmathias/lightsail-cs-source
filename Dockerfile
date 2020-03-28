FROM ubuntu:18.04
MAINTAINER Mathias Claes

# define default env variables
ENV MAP de_dust2
ENV MAXPLAYERS 16

# install dependencies
RUN apt-get update && \
    apt-get -qqy install lib32gcc1 curl unzip

# create directories
WORKDIR /root
RUN mkdir Steam .steam

# download steamcmd
WORKDIR /root/Steam

# download steamcmd
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# install CS Source via steamcmd
RUN ./steamcmd.sh +login anonymous +force_install_dir /css +app_update 232330 validate +quit

# Add Source Mods
COPY mods/ /temp
RUN cd /css/cstrike && \
    tar zxvf /temp/mmsource-1.10.6-linux.tar.gz && \
    tar zxvf /temp/sourcemod-1.7.3-git5275-linux.tar.gz && \
    unzip /temp/quake_sounds1.8.zip && \
    unzip /temp/mapchooser_extended_1.10.2.zip && \
    mv /temp/gem_damage_report.smx addons/sourcemod/plugins && \
    rm /temp/*
    
# Add Source Maps
COPY maps/ /temp
RUN cd /css/cstrike && \
    unzip /temp/maps.zip && \
    rm /temp/*

# start server
WORKDIR /css
ENTRYPOINT ./srcds_run -game cstrike -secure +maxplayers $MAXPLAYERS +map $MAP -port $PORT
