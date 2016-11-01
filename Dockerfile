FROM mesosphere/mesos-slave:0.28.2-2.0.27.ubuntu1404
MAINTAINER Klaus Ma <klaus1982.cn@gmail.com>

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -qqy \
        apt-transport-https \
        ca-certificates \
        curl \
        lxc \
        iptables \
        ipcalc \
        && \
    apt-get clean

# Install specific Docker version
ENV DOCKER_VERSION 1.11.2-0~trusty
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    mkdir -p /etc/apt/sources.list.d && \
    echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list && \
    apt-get update -qq && \
    apt-get install -y docker-engine=${DOCKER_VERSION} openjdk-7-jdk && \
    apt-get clean

ENV WRAPPER_VERSION 0.2.4
COPY ./wrapdocker /usr/local/bin/

ENTRYPOINT ["wrapdocker"]
CMD ["mesos-slave"]
