remote-notifications
====================

Receive remote notifications (e.g., from irc/mail running in a screen/tmux
session) and display them on your local machine.

A typical setup consists of one server running on your local PC that receives
messages from one or more clients that usually run on a remote PC. The received
messages are then forwarded to your notification daemon via `notify-send`

Setup
-----
- notify-send has to work on your local PC. Test it with `notify-send "foo bar"`
- I use remote-notifications that are tunneled via ssh. If you plan to use it
that way, add a RemoteForward entry to your `.ssh/config`:
```
Host yourserver
RemoteForward 22001 localhost:2225
```
- ssh yourserver

Local PC
--------
Start `notifyserver.lua`. The server listens for incoming connections on port
2225, reads the messages and executes notify-send.

Remote PC
---------
Start one of the provided client scripts and get notifications. Currently, there
is support for watching maildir folders and for irssi. The latter one can be
used for basically every program that logs notifications to a file.

License
-------
gplv3 (http://www.gnu.org/licenses/gpl-3.0.html)

