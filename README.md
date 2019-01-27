# Summary
InfluxDB is an open source time series database for recording metrics, events, and analytics.

# Settings
- Ports: 8086
- Data Directory: /var/lib/influxdb
- Default Configuration File: /etc/influxdb/influxdb.conf
- Custom Configuration File: use enviroment variable `INFLUXDB_CONFIG_PATH` or /usr/local/etc/influxdb/influxdb.conf

# Enviroment Variables
See: https://docs.influxdata.com/influxdb/v1.5/administration/config/#influxdb-environment-variables-influxdb

## DOCKER_INFLUXDB_ROOT_PASSWORD
This variable is mandatory and specifies the password that will be set for the `root` superuser account.

## DOCKER_INFLUXDB_DATABASE
This variable is optional and allows you to specify the name of a database to be created on image startup.
If a user/password was supplied (see below) then that user will be granted superuser access (corresponding to `GRANT ALL`) to this database.

## DOCKER_INFLUXDB_USER
These variables are optional, used in conjunction to create a new user.
This user will be granted superuser permissions (see above) for the database specified by the `DOCKER_INFLUXDB_DATABASE` variable.
Both variables are required for a user to be created.

## DOCKER_INFLUXDB_PASSWORD
These variables are optional, used in conjunction to set that user's password.
Do note that there is no need to use this mechanism to create the root superuser, that user gets created by default with the password specified by the `DOCKER_INFLUXDB_ROOT_PASSWORD` variable.

## DOCKER_INFLUXDB_RESET
These variables are optional, set `YES` to reset below variables.
