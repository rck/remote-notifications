#!/usr/bin/env lua

local lfs = require("lfs")
local socket = require("socket")

-- load config
dofile((os.getenv("HOME") .. "/.maildirwatch.lua"))

-- stuff from the config file
local hostname = hostname or "localhost"
local port = port or 22001
local sleeptime = sleeptime or 60
local cachemax = cachemax or 20
local ip = assert(socket.dns.toip(hostname))

-- global variables
local mailseen = {}
local incache = 0
local output = {}

local function sleep(n)
   os.execute("sleep " .. tonumber(n))
end

local function garbagecollect ()
   print ("trying to collect")
   for k in pairs(mailseen) do
      if not lfs.attributes(k) then
         print ("deleting chache entry for " .. k)
         mailseen[k] = nil
         incache = incache - 1
      else
         print ("still valid " .. k)
      end
   end
end

local function processdir (path)
   for file in lfs.dir(path .. "/new") do
      if file ~= "." and file ~= ".." then
         completefilepath = path .. "/new/" .. file
         if not mailseen[completefilepath] then 
            from, subject = nil, nil
            for line in io.lines(completefilepath) do
               if not from then
                  from = string.match(line, "^From: .+")
               end
               if not subject then
                  subject = string.match(line, "^Subject: .+")
               end
               if from and subject then break end
            end
            if from and subject then
               print (watchdirs[path] .. ": " .. from .. " " .. subject)
               table.insert(output, watchdirs[path] .. ": " .. from .. " " .. subject)

               mailseen[completefilepath] = true
               incache = incache + 1
            end
         end
      end
   end
end


while true do
   output = {}
   print("processing")
   for dir in pairs(watchdirs) do
      processdir (dir)
   end

   if #output > 0 then
      print("sending")
      local sd = assert(socket.tcp())
      sd:connect(hostname, port)

      for _,v in pairs(output) do
         sd:send(v .. '\n')
      end
      sd:close()
   else
      print("nothing to do")
   end

   print("cache: [" .. incache .. "/" .. cachemax .. "]")
   if incache >= cachemax then 
      garbagecollect ()
   end

   print("sleeping")
   sleep(sleeptime)
end

