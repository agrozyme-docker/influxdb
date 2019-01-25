#!/usr/bin/lua
local core = require("docker-core")

local function main()
  -- core.run("apk add --no-cache lua-rex-pcre")
  core.run("apk add --no-cache influxdb")
end

main()
