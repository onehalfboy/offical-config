#!/bin/bash
/bin/date >> /root2/code/store.log && /usr/bin/du -hd1 / >> /root2/code/store.log
/bin/date >> /root2/code/home_lynn.log && /usr/bin/du -hd1 /home/lynn  >> /root2/code/home_lynn.log
/bin/date >> /root2/code/home_lynn_cache.log && /usr/bin/du -hd1 /home/lynn/.cache  >> /root2/code/home_lynn_cache.log
/bin/date >> /root2/code/home_lynn_MyDocs.log && /usr/bin/du -hd1 /home/lynn/MyDocs  >> /root2/code/home_lynn_MyDocs.log
/bin/date >> /root2/code/var.log && /usr/bin/du -hd1 /var  >> /root2/code/var.log
/bin/date >> /root2/code/var_www.log && /usr/bin/du -hd1 /var/www  >> /root2/code/var_www.log
/bin/date >> /root2/code/var_www_web.log && /usr/bin/du -hd1 /var/www/web  >> /root2/code/var_www_web.log

