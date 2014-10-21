FROM debian:wheezy
MAINTAINER Bruno Binet <bruno.binet@gmail.com>

ENV GRAFANA_VERSION 1.8.1

RUN apt-get update && \
    apt-get install -y nginx-light wget apache2-utils && \
    wget http://grafanarel.s3.amazonaws.com/grafana-${GRAFANA_VERSION}.tar.gz -O grafana.tar.gz && \
    tar zxf grafana.tar.gz -C /data && \
    rm grafana.tar.gz && \
    apt-get purge -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD config.template.js /config.template.js
ADD nginx.config /etc/nginx/sites-enabled/default

# Environment variables for configuring InfluxDB datasources
#ENV METRICSDB metrics
#ENV METRICSDB_USER user
#ENV GRAFANADB grafana
#ENV GRAFANADB_USER admin
# Environment variables for HTTP AUTH
#ENV HTTP_USER grafana
#ENV HTTP_PASSWORD mypass

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
