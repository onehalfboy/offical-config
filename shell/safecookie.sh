#!/bin/bash
targetDir='/var/www/web/safety/bug_listener_online'
mkdir -p $targetDir
scp -r root@172.16.0.204:/opt/case/safety/bug_listener/* $targetDir/
#$1:butian $2:vulbox
ret=`php $targetDir/../updateCookie.php "$1" "$2"`
if [ "$ret" -eq "1" ]; then
 scp $targetDir/*.php root@172.16.0.204:/opt/case/safety/bug_listener/ 
 echo 'ok';
fi
