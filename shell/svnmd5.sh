#!/bin/bash
LOCK="/opt/case/monitor.2345.com/cache/log/md5sync.lock"
MD5FILE="/opt/case/monitor.2345.com/cache/log/md5sync.log"
LOG="/opt/shell/svnmd5.log"
rsynccmd='/opt/app/rsync/bin/rsync -avP --timeout=120 --port=3334 --password-file=/opt/app/rsync/etc/rsync.pas'
DIR='/opt/case/monitor.2345.com/clients'
DATE=`date`
#删除sync.cae文件中空行和空格行#
#sed -i '/^\s*$/d' ${MD5FILE}
main(){
         if [ -f ${MD5FILE} ];then
           sed -i '/^\s*$/d' ${MD5FILE}
           touch ${LOCK}
           while read line 
             do
               ip=`echo $line|awk '{print $1}'` && rdomain=`echo $line|awk '{print $2}'` && sdomain=`echo $line|awk '{print $3}'`
               ${rsynccmd} ${DIR}/${sdomain}/auto_check_client/ root@$ip::svn_auto_check/${rdomain}/auto_check_client/
               echo "${DATE} rsync ${sdomain} md5 to $ip ${rdomain}" >> ${LOG}
             done < ${MD5FILE}
            echo ${rdomain}
            rm -rf $MD5FILE && rm -rf $LOCK
         fi
       }
main
   
