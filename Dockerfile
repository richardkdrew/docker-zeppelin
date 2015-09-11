# DOCKER-VERSION 1.6.2
#
# Zeppelin Notebook Dockerfile
#
# https://github.com/richardkdrew/docker-zeppelin
#

FROM richardkdrew/maven:3.3.3

MAINTAINER Richard Drew <richardkdrew@gmail.com>

# install dependencies
RUN buildDeps='curl build-essential git python python-setuptools python-dev python-numpy' \
	&& apt-get update \
	&& apt-get install -y $buildDeps --no-install-recommends \
	&& apt-get clean

# ZEPPELIN
ENV ZEPPELIN_HOME=/usr/local/zeppelin

# get Zeppelin
RUN mkdir -p ${ZEPPELIN_HOME} \
	&& mkdir -p ${ZEPPELIN_HOME}/logs \
    && mkdir -p ${ZEPPELIN_HOME}/run \
    && cd /usr/local \
    && git clone https://github.com/apache/incubator-zeppelin.git \
    && mv /usr/local/incubator-zeppelin/* ${ZEPPELIN_HOME} \
# do some clean-up
    && rm -fr /usr/local/incubator-zeppelin

# install and configure Zeppelin
RUN	git config --global url.https://github.com/.insteadOf git://github.com/ \
    && cd ${ZEPPELIN_HOME} \
    && mvn clean package -DskipTests \
# do some clean-up
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/*

VOLUME [${ZEPPELIN_HOME}/notebook, ${ZEPPELIN_HOME}/logs]

EXPOSE 8080 8081

CMD ["/usr/local/zeppelin/bin/zeppelin.sh"]