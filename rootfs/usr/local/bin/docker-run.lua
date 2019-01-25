#!/usr/bin/lua
local core = require("docker-core")

local function main()
  core.update_user()
  core.mkdir("/var/lib/influxdb")
  core.run("su-exec core influxd")
end

main()
