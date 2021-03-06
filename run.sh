#!/bin/bash

set -e

abort() {
    echo "=> Environment was:"
    env
    echo "=> Program terminated!"
    exit 1
}

configure_basicauth() {
    if [ -z "${HTTP_USER}" ] || [ -z "${HTTP_PASSWORD}" ]; then
        echo "=> Aborting: the following 2 environment variables must be set:"
        echo "   - HTTP_USER"
        echo "   - HTTP_PASSWORD"
        abort
    else
        echo "=> Configuring basic auth for ${HTTP_USER} / ${HTTP_PASSWORD}."
        htpasswd -b -c /data/.htpasswd "${HTTP_USER}" "${HTTP_PASSWORD}"
    fi
}

configure_influxdb() {
    if [ -z "${METRICSDB}" ] || [ -z "${GRAFANADB}" ] ||
       [ -z "${METRICSDB_USER}" ] || [ -z "${GRAFANADB_USER}" ] ; then
        echo "=> Aborting: the following 4 environment variables must be set:"
        echo "   - METRICSDB & METRICSDB_USER"
        echo "   - GRAFANADB & GRAFANADB_USER"
        abort
    fi
    metricsdb_password="INFLUXDB_ENV_${METRICSDB}_${METRICSDB_USER}_PASSWORD"
    grafanadb_password="INFLUXDB_ENV_${GRAFANADB}_${GRAFANADB_USER}_PASSWORD"
    if [ -z "${!metricsdb_password}" ] || [ -z "${!grafanadb_password}" ]; then
        echo "=> Aborting: the following 2 environment variables must be set:"
        echo "   - ${metricsdb_password}"
        echo "   - ${grafanadb_password}"
        abort
    fi
    echo "=> Configuring InfluxDB..."
    sed -e "s/<--METRICSDB-->/${METRICSDB}/g" \
        -e "s/<--METRICSDB_USERNAME-->/${METRICSDB_USER}/g" \
        -e "s/<--METRICSDB_PASSWORD-->/${!metricsdb_password}/g" \
        -e "s/<--GRAFANADB-->/${GRAFANADB}/g" \
        -e "s/<--GRAFANADB_USERNAME-->/${GRAFANADB_USER}/g" \
        -e "s/<--GRAFANADB_PASSWORD-->/${!grafanadb_password}/g" \
        /config.template.js > /data/config.js
}

configure_influxdb
configure_basicauth

echo "=> Starting and running Nginx..."
nginx -g "daemon off;"
