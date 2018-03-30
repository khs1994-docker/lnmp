#!/bin/bash

set -ex

################################################################################

PGDATA=${PGDATA:-/pgdata}

################################################################################

function _start(){
    for soft in "$@"
    do
    echo -e "\033[31mStart $soft\033[0m...\n"
    case "$soft" in
      redis )
          if ! [ -f /run/redis.log ];then sudo touch /run/redis.log; fi
          sudo redis-server \
              --logfile /run/redis.log \
              --dir /tmp \
              --appendonly yes \
              --pidfile /run/redis.pid \
              --daemonize yes

      ;;

      mongodb )
         if ! [ -d /data/db ];then sudo mkdir -p /data/db ; fi

          sudo mongod \
              --fork --logpath=/run/mongodb.error.log \
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
              -R \
              -g /run/php-fpm.pid
      ;;

      nginx )
          if ! [ -f /etc/nginx/fastcgi.conf ];then sudo cp $WSL_HOME/lnmp/config/etc/nginx/fastcgi.conf /etc/nginx/fastcgi.conf ; fi

          sudo nginx -t
          # sudo nginx -g "pid /run/nginx.pid;"
          sudo nginx
      ;;

      postgresql )

      sudo mkdir -p "$PGDATA" || echo
      sudo chown -R "$(id -u)" "$PGDATA"
      sudo chmod 700 "$PGDATA"

      sudo mkdir -p /var/run/postgresql
      sudo chown -R "$(id -u)" /var/run/postgresql
      sudo chmod 777 /var/run/postgresql

      /usr/lib/postgresql/10/bin/pg_ctl -D "$PGDATA" \
                                        start
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
    echo -e "\033[31mStop $soft\033[0m...\n"
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

    postgresql )
        /usr/lib/postgresql/10/bin/pg_ctl -D "$PGDATA" stop
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

lnmp-wsl.sh status
"
fi

if [ "$1" = stop ];then
  shift
  if [ "$1" = 'all' ];then
    set +e
    clear
    _stop nginx mysql php redis memcached mongodb ssh postgresql
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
    _start nginx mysql php redis memcached mongodb ssh postgresql
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
    _restart nginx mysql php redis memcached mongodb ssh postgresql
    exit 0
  fi
  _restart "$@"
  exit 0
fi

if [ "$1" = 'status' ];then
    ps aux | grep nginx --color=auto
    echo "====>"
    ps aux | grep php-fpm --color=auto
    echo "====>"
    ps aux | grep mysql --color=auto
    echo "====>"
    ps aux | grep redis-server --color=auto
    echo "====>"
    ps aux | grep memcached --color=auto
    echo "====>"
    ps aux | grep mongod --color=auto
    echo "====>"
    ps aux | grep postgres --color=auto
    echo "====>"
    ps aux | grep sshd --color=auto
fi
