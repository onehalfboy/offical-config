#!/bin/bash
site=$1
mode=$2
backup=/opt/shell/ios.huaqianwy.com/backup
local=/opt/shell/ios.huaqianwy.com/local
if [ "$mode" == "toRemote" ]; then
	#backup
#	cp -f $site/config/config.inc.php $backup/
	cp -f $site/controllers/admin/IndexController.cls.php $backup/
#	cp -f $site/controllers/ios/ChannelController.cls.php $backup/
	cp -f $site/api/login.php $backup/
	#local
#	cp -f $local/config.inc.php $site/config/
	cp -f $local/IndexController.cls.php $site/controllers/admin/
#	cp -f $local/ChannelController.cls.php $site/controllers/ios/
	cp -f $local/login.php $site/api/
else
#        cp -f $backup/config.inc.php $site/config/
        cp -f $backup/IndexController.cls.php $site/controllers/admin/
#        cp -f $backup/ChannelController.cls.php $site/controllers/ios/
        cp -f $backup/login.php $site/api/
fi
