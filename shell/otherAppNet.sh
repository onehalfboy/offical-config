#!/bin/bash
datestr=`env LANG=en_US.UTF-8 date -u "+%a, %d %b %Y %H:%M:%S GMT"`
pwdstr=`echo -en ${datestr} | openssl dgst -sha1 -hmac u5fs_TwNUS-QBy1zSiap -binary | openssl enc -base64`
curl -s -X POST -u 2345dl:${pwdstr}  -H "Accept: application/xml"  -H "Date: ${datestr}" -d "resultType=1&channel=app.2345.cn" http://open.chinanetcenter.com/myview/serviceIp
