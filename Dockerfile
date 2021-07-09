FROM ubuntu:18.04
RUN apt update && apt install -y gnupg2 && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv AAE3CE82DA9BD4518ED53FC220221AFD63E0C3B9 && \
    { \
        echo "deb http://ppa.launchpad.net/fontforge/fontforge/ubuntu bionic main"; \
        echo "deb-src http://ppa.launchpad.net/fontforge/fontforge/ubuntu bionic main"; \
    } > /etc/apt/sources.list.d/fontforge.list && \
    apt update && \
    apt install -y --no-install-recommends \
        fontforge \
        python-pip \
        ttfautohint \
    && \
    pip2 install \
        fonttools \
    && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*
