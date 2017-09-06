#!/bin/bash

#ubuntu && vargrant up && vagrant ssh && sudo -i && /opt/shell/backup_vagrant.sh
dir="/opt/shell"

$dir/backup.sh
$dir/backup_mysqlvagrant.sh
$dir/rsync.sh
$dir/backupwww.sh

