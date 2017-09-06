#!/bin/bash
scp -r root@172.16.0.56:/opt/case/jieqian.2345.com/upload /var/www/web/jieqian.2345.com/
mysqldump -uroot -prcroot -h172.16.0.57 -B jieqian_2345_com > /var/www/web/jieqian.2345.com/docs/jieqian_2345_com.sql
mysqldump -uroot -prcroot -h172.16.0.57 -B jieqian_2345_com_user > /var/www/web/jieqian.2345.com/docs/jieqian_2345_com_user.sql
mysql -uroot -p888888 -h127.0.0.1 --port=3307 -e 'drop database jieqian_2345_com; source /var/www/web/jieqian.2345.com/docs/jieqian_2345_com.sql;'
mysql -uroot -p888888 -h127.0.0.1 --port=3307 -e 'drop database jieqian_2345_com_user; source /var/www/web/jieqian.2345.com/docs/jieqian_2345_com_user.sql;'
