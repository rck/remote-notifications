#!/bin/bash

#/set autolog in irssi

tail -n0 -q -f ~/irclogs/*/*.log |
egrep --line-buffered "yournick: " | 
{ while read line ; do echo $line | nc localhost 22001; done }
