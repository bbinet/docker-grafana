// == Configuration
// config.js is where you will find the core Grafana configuration. This file contains parameter that
// must be set before Grafana is run for the first time.

define(['settings'],
function (Settings) {
  

  return new Settings({

    /* Data sources
    * ========================================================
    * Datasources are used to fetch metrics, annotations, and serve as dashboard storage
    *  - You can have multiple of the same type.
    *  - grafanaDB: true    marks it for use for dashboard storage
    *  - default: true      marks the datasource as the default metric source (if you have multiple)
    *  - basic authentication: use url syntax http://username:password@domain:port
    */

    datasources: {
      influx: {
        type: 'influxdb',
        url: "http://<--INFLUXDB_HOST-->:8086/db/<--METRICSDB-->",
        username: "<--METRICSDB_USERNAME-->",
        password: "<--METRICSDB_PASSWORD-->",
        default: true
      },
      grafana: {
        type: 'influxdb',
        url: "http://<--INFLUXDB_HOST-->:8086/db/<--GRAFANADB-->",
        // user must have read/write access to the grafana database
        username: "<--GRAFANADB_USERNAME-->",
        password: "<--GRAFANADB_PASSWORD-->",
        grafanaDB: true
      }
    },

    /* Global configuration options
    * ========================================================
    */

    // specify the limit for dashboard search results
    search: {
      max_results: 20
    },

    // default home dashboard
    default_route: '/dashboard/file/default.json',

    // set to false to disable unsaved changes warning
    unsaved_changes_warning: true,

    // set the default timespan for the playlist feature
    // Example: "1m", "1h"
    playlist_timespan: "1m",

    // If you want to specify password before saving, please specify it bellow
    // The purpose of this password is not security, but to stop some users from accidentally changing dashboards
    // admin: {
    //   password: ''
    // },

    // Change window title prefix from 'Grafana - <dashboard title>'
    window_title_prefix: 'HeliosLite - ',

    // Add your own custom panels
    // plugins: {
    //   // list of plugin panels
    //   panels: [],
    //   // requirejs modules in plugins folder that should be loaded
    //   // for example custom datasources
    //   dependencies: [],
    // }

  });
});
