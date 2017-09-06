#!/bin/bash


    echo "<?php" > /opt/case/fabu.2345.com/checkmd5/union.2345.com.new/black.genMD5.php
    curl -s "http://monitor.2345.com/server/auto/getblacklist.php?domain=union.2345.com&apikey=41005867eaf971cd495aa8ccd1581b80" >> /opt/case/fabu.2345.com/checkmd5/$i
    echo $i
    #echo  "/opt/app/php5/bin/php /opt/case/fabu.2345.com/genMD5.php /opt/case/svn.2345.com/${i%/*} ${i%/*}"
    su -l duote.com -s /bin/bash -c "/opt/app/php5/bin/php /opt/case/fabu.2345.com/genMD5.php /opt/case/svn.2345.com/union.2345.com.new union.2345.com.new"
    wait
    cd `dirname /opt/case/fabu.2345.com/checkmd5/union.2345.com.new/black.genMD5.php`;touch md5.success;chown duote.com:duote.com md5.success
