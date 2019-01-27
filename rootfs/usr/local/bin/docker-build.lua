#!/usr/bin/lua
local core = require("docker-core")

local function main()
  local etc = "/etc/influxdb"
  -- core.run("apk add --no-cache lua-rex-pcre")
  core.run("apk add --no-cache influxdb")
  core.run("mv %s/influxdb.toml %s/influxdb.conf", etc, etc)
end

main()
