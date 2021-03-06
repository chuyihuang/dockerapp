FROM ubuntu:14.04
MAINTAINER Chuyi <chuyihuang@gmail.com>

#系統更新
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update --fix-missing
RUN apt-get upgrade -y
RUN apt-get install -y curl wget ca-certificates build-essential autoconf python-software-properties libyaml-dev

# Install nginx repositories
RUN wget http://nginx.org/keys/nginx_signing.key
RUN apt-key add nginx_signing.key
RUN echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list
RUN echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list

#其他系統資訊
RUN apt-get install -y libssl-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev bison openssl make git libsqlite3-dev nodejs nginx
#Mysql
RUN apt-get install -y mysql-server mysql-client libmysqld-dev


RUN apt-get clean

RUN echo %sudo    ALL=NOPASSWD: ALL >> /etc/sudoers

# Ruby-install
RUN wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz && tar -xzvf ruby-install-0.5.0.tar.gz && cd ruby-install-0.5.0/ && make install

# chruby
RUN wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz && tar -xzvf chruby-0.3.9.tar.gz && cd chruby-0.3.9/ && make install

RUN rm -rf /var/cache/apt/* /tmp/*

# Add a user just for running the app
RUN useradd -m -G sudo app

USER app
WORKDIR /home/app

# Install a Ruby version
RUN ruby-install ruby
RUN rm -rf /home/app/src

ADD docker-entrypoint.sh /home/app/docker-entrypoint.sh
# ADD setup.sh /home/app/setup.sh
ADD nginx.conf /home/app/nginx.conf

ENV RAILS_ENV=production

EXPOSE 80:80

ENTRYPOINT /home/app/docker-entrypoint.sh
