#!/bin/bash

set -e

function _start(){
    for soft in "$@"
    do
    echo -e "\nStart $soft ...\n"
    case "$soft" in
      redis )
          sudo redis-server \
              /etc/redis/redis.conf \
              --pidfile /run/redis.pid
      ;;

      mongodb )
          sudo mongod \
              --fork --logpath=/var/log/mongodb/.error.log \
              --pidfilepath /run/mongodb.pid
      ;;

      memcached )
          sudo memcached \
              -uroot \
              -d \
              -P /run/memcached.pid
      ;;

      php )
          sudo php-fpm \
              -D \
              -g /run/php-fpm.sock
      ;;

      nginx )
          sudo nginx -t
          # sudo nginx -g "pid /run/nginx.pid;"
          sudo nginx
      ;;

      * )
          sudo service $soft start
      ;;
esac
done
}

function _stop(){
  for soft in "$@"
  do
    echo -e "\nStop $soft ... \n"
  case "$soft" in
    php )
        sudo kill $(cat /run/php-fpm.pid)
    ;;

    nginx )
        # sudo nginx -s stop -g "pid /run/nginx.pid;"

        sudo nginx -s stop
    ;;

    redis )
        redis-cli shutdown
    ;;

    memcached )
        sudo kill $(cat /run/memcached.pid)
    ;;

    mongodb )
        sudo kill $(cat /run/mongodb.pid)
    ;;

    * )
        sudo service $soft stop
    ;;
  esac
done
}

_restart(){
  for soft in "$@"
  do
  _stop $soft
  _start $soft
done
}

if [ -z "$1" ];then
    exec echo -e "
lnmp-wsl.sh start | restart | stop SOFT_NAME

lnmp-wsl.sh start | restart | stop all
"
fi

if [ "$1" = stop ];then
  shift
  if [ "$1" = 'all' ];then
    set +e
    clear
    _stop nginx mysql php redis memcached mongodb ssh
    exit 0
  fi
  _stop "$@"
  exit 0
fi

if [ "$1" = start ];then
  shift
  if [ "$1" = 'all' ];then
    set +e
    clear
    _start nginx mysql php redis memcached mongodb ssh
    exit 0
  fi

  _start "$@"
  exit 0
fi

if [ "$1" = restart ];then
  shift
  if [ "$1" = 'all' ];then
    set +e
    clear
    _restart nginx mysql php redis memcached mongodb ssh
    exit 0
  fi
  _restart "$@"
  exit 0
fi
