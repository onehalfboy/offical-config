#!/bin/bash
dir="/var/www/config/vagrant/"

mkdir -p $dir

crontab -uwww-data -l > ${dir}crontab.txt

cp -rf /etc $dir
cp -rf /home/vagrant/.bashrc $dir
