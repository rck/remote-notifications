hostname = "localhost"
port = 22001

-- interval between checks in seconds
sleeptime = 60

-- number of entries before maildirwatch _tries_ to remove entries form the
-- internal cache. If entries in the cache are still valid, they are not
-- freed
cachemax = 20

-- maildirs to watch and a name that gets displayed
watchdirs = {
   ["/home/yourusername/.maildir/.user"] = "user",
   ["/home/yourusername/.maildir/.GMail"] = "Development",
   ["/home/yourusername/.maildir/.OpenBSD-tech"] = "OpenBSD-tech",
   ["/home/yourusername/.maildir/.debian-mips"] = "DebMips"
}
