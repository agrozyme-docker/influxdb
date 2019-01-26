#!/usr/bin/lua
local core = require("docker-core")

local function create_database()
  local database = core.getenv("DOCKER_INFLUXDB_DATABASE", "")

  if ("" ~= database) then
    core.run("influx -execute 'CREATE DATABASE %s' ", database)
  end
end

local function setup_database()
  local count = 30
  local command = string.format("influx -execute 'SHOW DATABASES' ")
  core.run("su-exec core influxd &")

  while (0 < count) do
    os.execute("sleep 1")

    if (os.execute(command)) then
      break
    end

    core.warn("InfluxDB init process in progress... ")
    count = count - 1
  end

  create_database()
  core.run("killall influxd")
  core.run("sleep 1")
end

local function main()
  core.update_user()
  core.mkdir("/run/influxdb", "/var/lib/influxdb")
  setup_database()
  core.run("su-exec core influxd")
end

main()
