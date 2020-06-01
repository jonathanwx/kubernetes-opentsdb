FROM openjdk:8u232-jdk

LABEL maintainer="jonathanlichi@gmail.com"

ARG OPENTSDB_VERSION=2.4.0
WORKDIR /tmp

# change apt source
# uncomment if needed
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
#   echo "deb http://mirrors.163.com/debian/ stretch main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian/ stretch-backports main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch-updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch-backports main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib">>/etc/apt/sources.list 

RUN apt-get update && apt-get install -y wget iputils-ping lsof gnuplot

RUN mkdir -p /etc/opentsdb
COPY conf/* /etc/opentsdb/
COPY scripts/start.sh /
RUN chmod +x /start.sh

RUN wget https://github.com/OpenTSDB/opentsdb/releases/download/v${OPENTSDB_VERSION}/opentsdb-${OPENTSDB_VERSION}_all.deb
# COPY opentsdb-${OPENTSDB_VERSION}_all.deb /
RUN dpkg -i opentsdb-${OPENTSDB_VERSION}_all.deb && chmod +x /usr/share/opentsdb/bin/tsdb


# fix bugs  https://help.aliyun.com/noticelist/articleid/1060035134.html
RUN rm -rf /usr/share/opentsdb/lib/jackson*
RUN wget -P /kafka/libs https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.9.10.4/jackson-databind-2.9.10.4.jar
RUN wget -P /kafka/libs https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.9.10/jackson-annotations-2.9.10.jar
RUN wget -P /kafka/libs https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.9.10/jackson-core-2.9.10.jar

# change time zone
RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

EXPOSE 4242

RUN rm -rf /tmp
WORKDIR /
ENTRYPOINT ["/start.sh"]