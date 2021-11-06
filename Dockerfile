FROM ubuntu:20.04
MAINTAINER OPADA-Eng
RUN apt-get update -y
RUN apt-get install imagemagick librsvg2-dev librsvg2-bin -y
RUN apt-get install graphicsmagick -y
RUN apt-get install wget -y
RUN apt-get install curl -y
RUN apt-get install git -y
RUN apt-get install vim nano -y
RUN apt-get install build-essential chrpath libssl-dev libxft-dev -y
RUN apt-get install libfreetype6 libfreetype6-dev -y
RUN apt-get install libjpeg-dev -y
RUN apt-get install libfontconfig1 libfontconfig1-dev -y 
RUN apt-get install -y fonts-hosny-thabit
RUN apt-get install -y fonts-arabeyes


ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_FRONTEND teletype

RUN apt-get update -y && apt-get install -y --no-install-recommends apt-utils 
RUN apt-get install ubuntu-restricted-extras -y
RUN apt-get install -y locales

RUN locale-gen ar_SA.UTF-8 
ENV LANG ar_SA.UTF-8
ENV LANGUAGE ar_SA:en  
ENV LC_ALL ar_SA.UTF-8

RUN wget -q -O /tmp/libpng12.deb http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
  && dpkg -i /tmp/libpng12.deb \
  && rm /tmp/libpng12.deb
  
# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Amman /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Install all Google Web Fonts
# dependancies: fonts-cantarell, ttf-ubuntu-font-family, git
RUN apt-get install fonts-cantarell -y 
RUN apt-get install ttf-ubuntu-font-family -y 
ENV srcdir "/tmp/google-fonts"
ENV pkgdir "/usr/share/fonts/truetype/google-fonts"
ENV giturl "git://github.com/google/fonts.git"

RUN mkdir $srcdir
RUN cd $srcdir
RUN echo "Cloning Git repository..."
RUN git clone $giturl

RUN echo "Installing fonts..."
RUN mkdir -p $pkgdir
RUN find $srcdir -type f -name "*.ttf" -exec install -Dm644 {} $pkgdir \;

RUN echo "Cleaning up..."
RUN find $pkgdir -type f -name "Cantarell-*.tff" -delete 
RUN find $pkgdir -type f -name "Ubuntu-*.tff" -delete 

# provides roboto
RUN apt-get --purge remove fonts-roboto

RUN echo "Updating font-cache..."
RUN fc-cache -f > /dev/null


ENV NODE_VERSION 16.13.0
# Install Node.js 8 and npm 5
RUN apt-get update
RUN apt-get -qq update
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
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


