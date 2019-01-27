#!/usr/bin/lua
local core = require("docker-core")

local function build_clause_statements(profile, items)
  if (("" ~= profile.database) and ("*" ~= profile.database)) then
    items[#items + 1] = string.format("CREATE DATABASE %q \n", profile.database)
  end

  if (("" ~= profile.user) and ("" ~= profile.database)) then
    items[#items + 1] = string.format("DROP USER %q \n", profile.user)
    items[#items + 1] = string.format("CREATE USER %q WITH PASSWORD '%s' \n", profile.user, profile.password)
    items[#items + 1] = string.format("REVOKE ALL PRIVILEGES FROM %q \n", profile.user)

    if ("*" == profile.database) then
      items[#items + 1] = string.format("GRANT ALL PRIVILEGES TO %q \n", profile.user)
    else
      items[#items + 1] = string.format("GRANT ALL ON %q TO %q \n", profile.database, profile.user)
    end
  end

  return items
end

local function build_startup_statements()
  local items = {}

  local profile = {
    user = "root",
    password = core.getenv("DOCKER_INFLUXDB_ROOT_PASSWORD", ""),
    database = "*"
  }

  build_clause_statements(profile, items)

  profile.user = core.getenv("DOCKER_INFLUXDB_USER", "")
  profile.password = core.getenv("DOCKER_INFLUXDB_PASSWORD", "")
  profile.database = core.getenv("DOCKER_INFLUXDB_DATABASE", "")
  build_clause_statements(profile, items)

  return items
end

local function setup_database(influxd)
  local count = 30
  local command = string.format("influx -execute 'SHOW DATABASES' ")
  local default = "/etc/influxdb/default.toml"
  core.run(influxd .. " &", default)

  while (0 < count) do
    os.execute("sleep 1")

    if (os.execute(command)) then
      break
    end

    core.warn("InfluxDB init process in progress... ")
    count = count - 1
  end

  if (0 == count) then
    error("InfluxDB init process failed.", 0)
  end

  local items = build_startup_statements()

  if (0 < #items) then
    local export = "/etc/influxdb/influxdb.sql"
    core.write_file(export, table.concat(items, ""))
    core.run("influx -import -path=%q", export)
    core.run("rm -f %q", export)
  end

  core.run("killall influxd")
  core.run("rm -f %q", default)
end

local function config()
  local paths = {
    core.getenv("INFLUXDB_CONFIG_PATH", ""),
    "/usr/local/etc/influxdb/influxdb.conf",
    "/etc/influxdb/influxdb.conf"
  }

  for _, path in pairs(paths) do
    if (("" ~= path) and core.test("-f %q", path)) then
      return path
    end
  end
end

local function main()
  core.update_user()
  core.mkdir("/run/influxdb", "/var/lib/influxdb")
  local influxd = "su-exec core influxd run -config %q"
  local reset = core.getenv("DOCKER_INFLUXDB_RESET", "")

  if (core.boolean(reset)) then
    setup_database(influxd)
  end

  core.run(influxd, config())
end

main()
