FROM ubuntu:18.04

RUN apt update && \
    apt upgrade -y && \
    apt install -y \
    apt-utils \
    unzip \
    curl \
    wget \
    jq

# Set timezone to Europe/Copenhagen
RUN ln -s /usr/share/zoneinfo/Europe/Copenhagen /etc/localtime

# Python 3.6 & Pip
RUN apt install -y python3.6 python3-pip && \
    ln -s /usr/bin/python3.6 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

# AWS Cli
RUN pip install awscli --upgrade --user && \
    cp ~/.local/bin/aws /usr/local/bin

# Docker
RUN apt install -y apt-transport-https software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" && \
    apt update && \
    apt install -y docker-ce && \
    usermod -aG docker root

# NodeJS
RUN wget https://deb.nodesource.com/setup_8.x && bash setup_8.x && apt-get install -y --no-install-recommends nodejs && rm setup_8.x

# Bower, Gulp & node-sass
RUN npm install -g bower && npm install -g gulp
RUN npm install node-sass

# PHP
ENV DEBIAN_FRONTEND=noninteractive
RUN add-apt-repository ppa:ondrej/php && \
    apt update && \
    apt upgrade -y
RUN apt-get install -y --no-install-recommends php7.4 php7.4-bcmath php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-odbc php7.4-opcache php7.4-pgsql php7.4-soap php7.4-xml php7.4-zip php7.4-ldap
COPY php.ini /etc/php/7.4/cli/php.ini

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm composer-setup.php && composer global require hirak/prestissimo

# Cleanup
RUN apt autoclean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/bin/bash"]