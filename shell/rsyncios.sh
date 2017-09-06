#!/bin/bash
site=$1
branch=$2
mode=$3
if [ "$site" == "" ]; then
	site="/root2/code/web/jieqian.2345.com"
fi
if [ "$mode" == "" ]; then
	mode="update"
fi
if [ "$branch" == "" ]; then
	branch="test"
fi

ios=/opt/shell/ios.huaqianwy.com

CMD=/usr/bin/rsync 
check="-cnzrlD  --progress --bwlimit=1024 --password-file=/opt/shell/ios.huaqianwy.com/rsync.pas  --timeout=600 --port=3334"
checkdelete="-cnzrlD --delete --progress --bwlimit=1024 --password-file=/opt/shell/ios.huaqianwy.com/rsync.pas  --timeout=600 --port=3334"
update="-czrlD --progress --bwlimit=1024 --password-file=/opt/shell/ios.huaqianwy.com/rsync.pas  --timeout=600 --port=3334"
delete="-czrlD --progress --bwlimit=1024 --delete --password-file=/opt/shell/ios.huaqianwy.com/rsync.pas  --timeout=600 --port=3334"

if [ "$mode" == "check" ]; then
	PARM=$check
elif [ "$mode" == "checkdelete" ]; then
	PARM=$checkdelete
elif [ "$mode" == "update" ]; then
	PARM=$update
elif [ "$mode" == "delete" ]; then
	PARM=$delete
fi 

cd $site
if [ "$branch" != "nothing" ]; then
	git checkout $branch -f
	git pull origin $branch
fi
$ios/change.sh $site toRemote

$CMD $PARM --exclude-from=$ios/exclude.list $site/ httpd@112.74.187.90::ios

$ios/change.sh $site backup
