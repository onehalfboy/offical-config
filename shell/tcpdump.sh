#!/bin/bash
pidFile="/tmp/tcpdump.pid"
echo $$ > $pidFile;

while [ -f $pidFile ];
do
 length=$(tcpdump tcp -i eth0 -XvvennSs 0 -t -c 1 and src port 8080 | awk '{if($21=="length" && $22>20) exit;} END {print $22}')
 if [ ! -z "$length" ] && [ "$length" -gt "20" ]; then
  echo 1 | nc -u -w 3 127.0.0.1 3000
 fi
 sleep 1s;
done
