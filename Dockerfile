FROM ubuntu:16.04
MAINTAINER OPADA-Eng
RUN apt-get update -y
RUN apt-get install imagemagick librsvg2-dev librsvg2-bin -y
RUN apt-get install graphicsmagick -y
RUN apt-get install wget -y
RUN apt-get install build-essential chrpath libssl-dev libxft-dev -y
RUN apt-get install libfreetype6 libfreetype6-dev -y
RUN apt-get install libfontconfig1 libfontconfig1-dev -y
RUN curl -o- -L https://yarnpkg.com/install.sh > /usr/local/bin/yarn-installer.sh

# Install node.js
USER buildbot
RUN git clone https://github.com/creationix/nvm.git ~/.nvm && \
    cd ~/.nvm && \
    git checkout v0.33.4 && \
    cd /

ENV ELM_VERSION=0.17.1
ENV YARN_VERSION=1.3.2

RUN /bin/bash -c ". ~/.nvm/nvm.sh && \
         nvm install 8 && nvm use 8 && npm install -g sm grunt-cli bower elm@$ELM_VERSION && \
             bash /usr/local/bin/yarn-installer.sh --version $YARN_VERSION && \
         nvm alias default node && nvm cache clear"

USER root
