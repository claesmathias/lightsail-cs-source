FROM ubuntu:18.04
MAINTAINER Mathias Claes

# define default env variables
ENV MAP de_dust2
ENV MAXPLAYERS 16
# Disable validation mode by default
ENV CHECKFILES "false"

# prepare container for steam
RUN apt-get update \
    && apt-get -y install lib32gcc1 wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && mkdir -p /data/steam/backup \
    && useradd -d /data/steam -s /bin/bash --uid 1000 steam \
    && chown -R steam /data/steam

# add control script
COPY css.sh /usr/local/bin/css

#change user annd working dir
USER steam
VOLUME /data/steam
WORKDIR /data/steam

# set entry point
CMD ["css"]
