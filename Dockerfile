FROM ubuntu:xenial
MAINTAINER Johannes Gontrum <admin@sengiai.com>

# Locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && apt-get install -y locales && locale-gen en_US.UTF-8 && \
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

# SSH Server
RUN apt-get -q update &&\
    apt-get -q install -y openssh-server &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

# Utils
RUN apt-get -q update &&\
    apt-get -q install -y \
        git \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

# JDK8, sometimes needed by Jenkins master
RUN apt-get -q update &&\
    add-apt-repository -y ppa:openjdk-r/ppa &&\
    apt-get -q update &&\
    apt-get -q install -y \
        openjdk-8-jre-headless &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

# Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - &&\
    apt-key fingerprint 0EBFCD88 &&\
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" &&\
    apt-get update &&\
    apt-get install -y docker-ce &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

# User
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "jenkins:jenkins" | chpasswd &&\
    usermod -a -G docker jenkins

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
