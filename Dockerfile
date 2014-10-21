FROM debian:wheezy
MAINTAINER Bruno Binet <bruno.binet@gmail.com>

ENV GRAFANA_VERSION 1.8.1

RUN apt-get update && \
    apt-get install -y nginx-light wget apache2-utils && \
    wget http://grafanarel.s3.amazonaws.com/grafana-${GRAFANA_VERSION}.tar.gz -O grafana.tar.gz && \
    tar zxf grafana.tar.gz && \
    rm grafana.tar.gz && \
    mv grafana-${GRAFANA_VERSION} /data && \
    apt-get purge -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD config.template.js /config.template.js
ADD nginx.config /etc/nginx/sites-enabled/default

ADD run.sh /run.sh
RUN chmod +x /run.sh

# Environment variables for configuring InfluxDB datasources
#ENV METRICSDB metrics
#ENV METRICSDB_USER user
#ENV GRAFANADB grafana
#ENV GRAFANADB_USER admin
# Environment variables for HTTP AUTH
#ENV HTTP_USER grafana
#ENV HTTP_PASSWORD mypass

EXPOSE 80

CMD ["/run.sh"]
