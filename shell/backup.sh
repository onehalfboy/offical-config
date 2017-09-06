#!/bin/bash
dir="/var/www/config/local/"
toolDir="/var/www/config/tools/"
shellDir="/var/www/config/shell/"
srcDir="/var/www/config/local/src/"

mkdir -p $dir
mkdir -p $toolDir
mkdir -p $shellDir
mkdir -p $srcDir

crontab -l > ${dir}crontab.txt

cp -rf /etc $dir
cp -rf /root2/docs $dir
cp -rf /home/lynn/.bashrc $dir
cp -rf /home/lynn/vagrant/ubuntu32/Vagrantfile $dir
cp -rf /opt/shell/* $shellDir
cp -rf /opt/src/*.zip $srcDir
cp -rf /opt/src/*.gz $srcDir
cp -rf /opt/app/nginx $dir
cp -rf /root2/originalFiles/tools/google/chrome/google_chrome_plugins/good ${toolDir}google_chrome_plugins

cp -rf /var/www/web/issue.2345.com/docs/*.sh $shellDir
cp -rf /var/www/web/oa.issue.2345.net/docs/*.sh $shellDir
cp -rf /var/www/web/release.2345.net/docs/*.sh $shellDir
cp -rf /var/www/web/release.2345.net/console/index.sh $shellDir
cp -rf /var/www/web/ccser.2345.net/console/*.sh $shellDir
cp -rf /var/www/web/monitor.2345.com/docs/*.sh $shellDir
cp -rf /usr/bin/mysql123 $shellDir
cp -rf /usr/bin/mysqllocalhost $shellDir
cp -rf /usr/bin/mysqlvagrant $shellDir
cp -rf /usr/bin/mysql236 $shellDir
cp -rf /usr/bin/mysql57 $shellDir
