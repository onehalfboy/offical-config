#!/bin/bash
branch=master
cd /root2/code/web/daikuan.2345.com/
git checkout $branch -f
git pull origin $branch
scp -r /root2/code/web/daikuan.2345.com root@172.16.0.56:/opt/case/
