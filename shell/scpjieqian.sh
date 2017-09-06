#!/bin/bash
branch=test
cd /root2/code/web/jieqian.2345.com/
git checkout $branch -f
git pull origin $branch
rm /tmp/upload -rf
mv upload /tmp/ 
if [ "$1" == "-dc" ];then
	rm /tmp/config.inc.php
	mv config/config.inc.php /tmp/ 
fi
scp -r /root2/code/web/jieqian.2345.com root@172.16.0.56:/opt/case/
