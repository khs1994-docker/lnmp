#!/bin/bash

case $1 in
  mongod | mongodb )
    if [ "$2" = 'start' ];then
      mongod --config /usr/local/etc/mongod.conf
    elif [ "$2" = 'stop' ];then
      sudo kill `cat /var/run/mongodb.pid`
    elif [ "$2" = 'status' ];then
      ps aux | grep mongod --color=auto
    fi
    ;;

  postgres | postgresql )

    # init
    # pg_ctl -D /usr/local/var/postgres init

    if [ "$2" = 'start' ];then
      pg_ctl -D /usr/local/var/postgres start
    elif [ "$2" = 'stop' ];then
      pg_ctl -D /usr/local/var/postgres stop
    elif [ "$2" = 'status' ];then
      ps aux | grep postgres --color=auto
    elif [ "$2" = 'restart' ];then
      pg_ctl -D /usr/local/var/postgres restart
    fi
    ;;

  stop )
     php72-fpm stop
     sudo nginx -s stop
     mysql.server stop
     sudo kill `cat /var/run/redis_6379.pid`
     sudo kill `cat /var/run/memcached.pid`
     ;;

   start )
     sudo nginx
     # sudo php-fpm -R
     mysql.server start
     php72-fpm start
     sudo redis-server /usr/local/etc/redis.conf
     sudo memcached -uroot -d -P /var/run/memcached.pid
     ;;

   shutdown )
       sudo nginx -s stop
       mysql.server stop
       php72-fpm stop
       sudo kill `cat /var/run/redis_6379.pid`
       sudo kill `cat /var/run/memcached.pid`
       sudo kill `cat /var/run/mongodb.pid`
       pg_ctl -D /usr/local/var/postgres stop
       ;;

   status )
        ps aux | grep nginx --color=auto
        ps aux | grep php --color=auto
        ps aux | grep mysql --color=auto
        ps aux | grep redis --color=auto
        ps aux | grep memcached --color=auto
        ps aux | grep mongod --color=auto
        ps aux | grep postgres --color=auto
        ;;

   * )
   echo "
Usage:

$0 {start|stop|restart|reload|force-reload|status}
$0 mongodb {start|stop|restart|reload|force-reload|status}
$0 postgresql {start|stop|restart|reload|force-reload|status}
"

   esac
