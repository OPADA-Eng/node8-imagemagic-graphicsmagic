FROM ubuntu:16.04
MAINTAINER OPADA-Eng
RUN apt-get update -y
RUN apt-get install imagemagick librsvg2-dev librsvg2-bin -y
RUN apt-get install graphicsmagick -y
RUN apt-get install wget -y
RUN apt-get install curl -y
RUN apt-get install git -y
RUN apt-get install build-essential chrpath libssl-dev libxft-dev -y
RUN apt-get install libfreetype6 libfreetype6-dev -y
RUN apt-get install libfontconfig1 libfontconfig1-dev -y 

ENV NODE_VERSION 8.12.0
# Install Node.js 8 and npm 5
RUN apt-get update
RUN apt-get -qq update
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -y nodejs

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y 

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh


# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation
RUN node -v
RUN npm -v
