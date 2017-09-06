#!/bin/bash

# Version:      1.0
# Author:       ming
# Date:         2012-06-06

# 说明:
#	1: Apache prefork安装
# 	2: yum安装依赖库
#	3: 配置文件同步

# 定义变量
RETVAL=0

# MySQL默认密码
MYSQL_PASS="qggahjtg"

# LAMP5目录
LAMP="/opt/src/LAMP5"

# TPL
TPL_CONF="tpl_conf"
TPL_CONF_TAR="${TPL_CONF}.tar.bz2"

# cronolog
CRONOLOG="rc_cronolog"
PURE_FTPD="rc_pure-ftpd"

# LAMP5版本名
APACHE="httpd-2.2.22"
MYSQL="mysql-5.1.56"
PHP="php-5.3.10-e-rfc"
APACHE_TAR="${APACHE}.tar.bz2"
MYSQL_TAR="${MYSQL}.tar.gz"
PHP_TAR="${PHP}.tar.bz2"

# LOG
LOG_DIR="/opt/logs"
APACHE_LOG="${LOG_DIR}/apache2/"

# LAMP5 源码下载地址
DIR_URL="http://183.136.203.103:809/Source/LAMP5"
APACHE_URL="${DIR_URL}/${APACHE_TAR}"
MYSQL_URL="${DIR_URL}/${MYSQL_TAR}"
PHP_URL="${DIR_URL}/${PHP_TAR}"
TPL_CONF_URL="${DIR_URL}/${TPL_CONF_TAR}"



# 配置文件同步
TPL_APACHE_CONF="${LAMP}/${TPL_CONF}/apache2/conf/"
APACHE_CONF="/opt/app/apache2/conf/"
TPL_MYSQL_MASTER_CONF="${LAMP}/${TPL_CONF}/mysql5/my.cnf.master"
TPL_MYSQL_SLAVE_CONF="${LAMP}/${TPL_CONF}/mysql5/my.cnf.slave"
MYSQL_CONF="/etc/my.cnf"
TPL_PHP_CONF="${LAMP}/${TPL_CONF}/php5/php.ini"
TPL_PHP_CONF_MEMCACHE="${LAMP}/${TPL_CONF}/php5/php.ini-memcache"
PHP_CONF="/opt/app/php5/etc/php.ini"

# 
#http://122.227.230.166:809/CentOS-Base-sohu.repo
#http://122.227.230.166:809/epel-release-5-4.noarch.rpm

tpl_conf() {
	if [ ! -d ${LAMP} ]; then
		mkdir -p ${LAMP}
	fi

	cd ${LAMP}
	
	if [ ! -f ${TPL_CONF_TAR} ]; then
		wget -S ${TPL_CONF_URL}
	fi

        if [ ! -d ${TPL_CONF} ]; then
		tar -jxvf ${TPL_CONF_TAR}
        fi
}

# 提示
apache_notice() {
        echo  -e "
|notice:
        echo '/opt/app/apache2/bin/apachectl -k start' >>  /etc/rc.local
end|\n"
}

mysql_server_notice() {
        echo  -e "
|notice:
        echo '/opt/app/mysql5/share/mysql/mysql.server start' >>  /etc/rc.local
end|\n"
}

pure_ftpd_notice() {
        echo  -e "
|notice:
        echo '/opt/app/pureftpd/sbin/pure-config.pl /opt/app/pureftpd/etc/pure-ftpd.conf' >>  /etc/rc.local
end|\n"
}

# 安装apache2
apache() {
	apache_install
	apache_notice
	# 安装apache后安装cronolog
	cronolog
}

apache_install() {
	tpl_conf
	__apache_install_bef
	__apache_install	
	__apache_install_aft
}

__apache_install_bef() {
        yum -y install zlib-devel openssl-devel

        cd ${LAMP}
	if [ ! -f ${APACHE_TAR} ]; then
		wget -S ${APACHE_URL}
	fi

        if [ ! -d ${APACHE} ]; then
		tar -jxvf ${APACHE_TAR}
        fi
}

__apache_install() {
        cd ${LAMP}/${APACHE}
        CONFIG="./configure --prefix=/opt/app/apache2 --disable-authn-file --disable-userdir --enable-authn-anon --enable-deflate --enable-expires --enable-mods-shared=all --enable-rewrite --enable-so --enable-ssl --with-included-apr --with-mpm=prefork --with-z"
	
	# work 不用ssl
	# ./configure --prefix=/opt/app/apache2 --disable-authn-file --disable-userdir --enable-authn-anon --enable-deflate --enable-expires --enable-mods-shared=all --enable-rewrite --enable-so --with-included-apr --with-mpm=worker --with-z
	${CONFIG} && make && make install
}

__apache_install_aft() {
	useradd -u2000 -d /dev/null -s /sbin/nologin httpd -M
	mkdir -p /opt/case/null/
	chown -R httpd:httpd /opt/case/null/
	# 同步配置文件
	rsync --delete -a ${TPL_APACHE_CONF} ${APACHE_CONF}
	if [ ! -d ${APACHE_LOG} ]; then
		mkdir -p ${APACHE_LOG}
	fi
}

# 安装mysql5
mysql() {
	mysql_install
}

mysql_install() {
	tpl_conf
	__mysql_install_bef
	__mysql_install
}

# mysql5 server安装脚本
mysql_master() {
	mysql_master_install
	mysql_server_notice
}

mysql_master_install() {
	mysql_install

	# mysql master需运行
	__mysql_master_install_aft
}


mysql_slave() {
	mysql_slave_install
	mysql_server_notice
}

mysql_slave_install() {
	mysql_install

        # mysql slave需运行
        __mysql_slave_install_aft
}

__mysql_install_bef() {
	yum -y install ncurses-devel.x86_64
	
	cd ${LAMP}
        if [ ! -f ${MYSQL_TAR} ]; then
                wget -S ${MYSQL_URL}
        fi

        if [ ! -d ${MYSQL} ]; then
        	tar -zxvf ${MYSQL_TAR}
        fi
}

__mysql_install() {
        cd ${LAMP}/${MYSQL}
        # gbk
	CONFIG="./configure --prefix=/opt/app/mysql5 --enable-assembler --enable-static --with-big-tables --with-charset=gbk --with-client-ldflags=-all-static --with-collation=gbk_chinese_ci --with-comment=Source --with-extra-charsets=all --with-mysqld-ldflags=-all-static --with-mysqld-user=mysql --without-ndb-debug --with-plugins=innobase --with-pthread --with-server-suffix=-leysin"

	${CONFIG} && make && make install
}

__mysql_master_install_aft() {
        # 同步配置文件
        rsync -a ${TPL_MYSQL_MASTER_CONF} ${MYSQL_CONF}
	__mysql_install_aft
}

__mysql_install_aft() {
	useradd -u2001 -d /dev/null -s /sbin/nologin -M mysql
	mkdir -p /opt/app/mysql5/{logs,var,varinnodb,tmp}
	#tmpdir = /opt/app/mysql5/tmp
	chown -R mysql:mysql /opt/app/mysql5/
	/opt/app/mysql5/bin/mysql_install_db --user=mysql
	#/opt/app/mysql5/share/mysql/mysql.server start
	#/opt/app/mysql5/bin/mysqladmin -u root password ${MYSQL_PASS}					# qggahjtg
	# grant replication slave on *.* to dbslave@'192.168.2.%' identified by 'ruichuang@dbslave';	# 数据库主从同步
	# grant process, super on *.* to 'rc_status'@'192.168.2.%' identified by 'rc_status';		# 监控数据库主从
	# grant process, super on *.* to 'rc_status'@'127.0.0.1' identified by 'rc_status';		# monitor_db
}

__mysql_slave_install_aft() {
        rsync -a ${TPL_MYSQL_SLAVE_CONF} ${MYSQL_CONF}
	__mysql_install_aft
}

# 安装php5
php() {
	php_install
}

php_install() {
	tpl_conf
	__php_install_bef
	__php_install
	__php_install_aft
}

__php_install_bef() {
	yum -y install libxml2-devel php-gd libjpeg-devel libpng-devel freetype-devel libmcrypt-devel curl-devel
	ln -s /usr/lib64/libjpeg.so /usr/lib/libjpeg.so
	ln -s /usr/lib64/libpng.a /usr/lib/libpng.a
	ln -s /usr/lib64/libpng.so /usr/lib/libpng.so

        cd ${LAMP}
        if [ ! -f ${PHP_TAR} ]; then
                wget -S ${PHP_URL}
        fi

        if [ -d ${PHP} ]; then
                rm -rf ${PHP}
        fi
        
        tar -jxvf ${PHP_TAR}
}

__php_install() {
	cd ${LAMP}/${PHP}	
        CONFIG="./configure --prefix=/opt/app/php5 --disable-ipv6 --enable-dba --enable-ftp --enable-magic-quotes --enable-mbstring --enable-sockets --with-apxs2=/opt/app/apache2/bin/apxs --with-config-file-path=/opt/app/php5/etc --with-curl --with-freetype-dir --with-gd --with-jpeg-dir --with-mcrypt --with-mhash --with-mysql=/opt/app/mysql5 --with-mysqli=/opt/app/mysql5/bin/mysql_config --with-openssl --with-pdo-mysql=/opt/app/mysql5/ --with-zlib"
	${CONFIG} && make && make install
}

__php_install_aft() {
        rsync -a ${TPL_PHP_CONF} ${PHP_CONF}
	# /tmp/sessions 10天不使用会被删除，所以改成/opt/case/sessions [Date: 2013-03-07]
	mkdir -p /opt/case/sessions
	chown -R httpd:httpd /opt/case/sessions
	mkdir -p /opt/case/phpexec
	chown -R httpd:httpd /opt/case/phpexec
}

php_memcache() {
        php_memcache_install
}

php_memcache_install() {
	/opt/app/php5/bin/pecl install memcache
        rsync -a ${TPL_PHP_CONF_MEMCACHE} ${PHP_CONF}
}

# 安装lamp，其中mysql不带server
lamp() {
	apache_install
	mysql_install
	php_install
	apache_notice
}

# 安装lamp，其中带mysql server
laMp() {
        apache_install
        mysql_master_install
        php_install
        apache_notice
	mysql_server_notice
}

case "$1" in
	apache)
		apache
		;;
	mysql)
		mysql
		;;
	mysql_master)
		mysql_master
		;;
	mysql_slave)
		mysql_slave
		;;
	php)
		php
		;;
	php_memcache)
		php_memcache
		;;
	lamp)
		lamp
		;;
	laMp)
		laMp
		;;
	*)
		echo $"Usage: $0 {apache|mysql|mysql_master|mysql_slave|php|php_memcache|lamp|laMp}"
		RETVAL=1
esac
exit ${RETVAL}
