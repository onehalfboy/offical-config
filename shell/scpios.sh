#!/bin/bash
branch=$1
if [ "$branch" == "" ]; then
        branch="test"
fi
site=/root2/code/web/jieqian.2345.com
ios=/opt/shell/ios.huaqianwy.com
cd $site
git checkout $branch -f
git pull origin $branch
mkdir /root2/tmp
mv upload /root2/tmp/ 
mv .git /root2/tmp/ 
$ios/change.sh $site toRemote

scp -r $site root@112.74.187.90:/opt/case/

$ios/change.sh $site backup
mv /root2/tmp/.git ./
mv /root2/tmp/upload ./
