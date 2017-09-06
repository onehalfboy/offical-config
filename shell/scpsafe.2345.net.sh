#!/bin/bash
cd /root2/code/web/safe.2345.net/
git pull origin master
rm upload -rf
scp -r /root2/code/web/safe.2345.net root@172.16.0.56:/opt/case/
