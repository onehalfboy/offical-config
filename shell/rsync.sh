#!/bin/bash
## $1  对应脚本执行方法
## $2  项目名称


CMD=/usr/bin/rsync
PARM="-cnzrlD  --progress --bwlimit=1024 --timeout=600 --port=837"
PARM2="-czrlD --progress --bwlimit=1024 --timeout=600 --port=837"

RSYNCPATHA='/var/www/';
RSYNCPATHB='/root2/backup/var_www/';

if [ ! -d ${RSYNCPATHA} ];then
   echo '不存在源同步项目目录' > /dev/stderr;
   exit 2;
fi;

if [ ! -d ${RSYNCPATHB} ];then
   echo '不存在项目目录' > /dev/stderr;
   exit 2;
fi;

./backup.sh

${CMD} ${PARM2} --exclude-from=/root2/backup/exclude.list ${RSYNCPATHA} ${RSYNCPATHB}
