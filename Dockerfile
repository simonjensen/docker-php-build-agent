FROM ubuntu:18.04

RUN apt update && \
    apt upgrade -y && \
    apt install -y \
    curl \
    wget \
    jq

# Python & Pip
RUN apt install -y python python-pip

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

# Bower
RUN npm install -g bower && npm install -g gulp

# PHP
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y --no-install-recommends php7.2 php7.2-bcmath php7.2-curl php7.2-gd php7.2-intl php7.2-json php7.2-mbstring php7.2-mysql php7.2-odbc php7.2-opcache php7.2-pgsql php7.2-soap php7.2-xml php7.2-zip

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm composer-setup.php && composer global require hirak/prestissimo

# Cleanup
RUN apt autoclean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/bin/bash"]