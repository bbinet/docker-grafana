docker-grafana
==============

Grafana dashboard for InfluxDB docker container.


Build
-----

To create the image `bbinet/grafana`, execute the following command in the
`docker-grafana` folder:

    docker build -t bbinet/grafana .

You can now push the new image to the public registry:
    
    docker push bbinet/grafana


Configure and run
-----------------

You can configure the Grafana running container with the following required
environment variables:


- `METRICSDB`: InfluxDB database in which grafana should query the metrics.
- `METRICSDB_USER`: Username to use to connect to the above database (the
  password will be read from InfluxDB docker environment variables).
- `GRAFANADB`: InfluxDB database in which grafana should persist all the
  dashboards.
- `GRAFANADB_USER`: Username to use to connect to the above database (the
  password will be read from InfluxDB docker environment variables).
- `HTTP_USER`: Username for HTTP auth.
- `HTTP_PASSWORD`: Password for HTTP auth.

Then when starting your InfluxDB container, you will want to bind ports `80`
from the Grafana container to the host external ports.
The container should also be linked with the InfluxDB container so that it can
read the InfluxDB host ip address and the users passwords from the environment
variables.

For example:

    $ docker pull bbinet/grafana

    $ docker run --name influxdb \
          --link influxdb:influxdb \
          -p 80:80 \
          -e METRICSDB=metrics \
          -e METRICSDB_USER=user \
          -e GRAFANADB=grafana \
          -e GRAFANADB_USER=admin \
          -e HTTP_USER=myuser \
          -e HTTP_PASSWORD=mypass \
          bbinet/grafana

