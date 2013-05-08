#!/usr/bin/env lua

local socket = require("socket")

local hostname = "localhost"
local port = 2225

local sd = assert(socket.tcp())
local ip = assert(socket.dns.toip(hostname))
sd:bind(ip, port)
sd:listen(5)

while true do
   print("waiting for new client")
   client = sd:accept()
   line = client:receive()
   while line do
      -- add some minimal security, as we call sh -c
      -- http://php.net/manual/en/function.escapeshellcmd.php
      line = string.gsub(line, "([%c\\%#%&%;%`%|%*%?%~%<%>%^%(%)%[%]%{%}%$])", '_')

      print("Msg: " .. line)
      os.execute("notify-send -t 5000 " .. "'" .. line .. "'")
      line = client:receive()
   end
   client:close()
end
