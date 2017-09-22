#!/bin/bash

VERSION=v17.09-rc3

logs(){
  # 创建日志文件

  echo -e "\033[32mINFO\033[0m  mkdir log folder\n"

  cd logs

  rm -rf mongodb \
         mysql \
         nginx \
         php-fpm \
         redis
  cd -

  mkdir -p logs/mongodb
  cd logs/mongodb
  touch mongo.log

  # 部分文件可能提示没有写入权限

  chmod 777 *
  cd -

  mkdir -p logs/mysql
  cd logs/mysql
  echo > error.log
  chmod 777 *
  cd -

  mkdir -p logs/nginx
  cd logs/nginx
  echo > error.log
  echo > access.log
  chmod 777 *
  cd -

  mkdir -p logs/php-fpm
  cd logs/php-fpm
  echo > error.log
  echo > access.log
  echo > xdebug-remote.log
  chmod 777 *
  cd -

  mkdir -p logs/redis
  cd logs/redis
  echo > redis.log
  chmod 777 *
  cd -

  cd tmp
  rm -rf cache
  mkdir cache
  chmod 777 cache
  cd -

  echo -e "\n\033[32mINFO\033[0m  mkdir log folder SUCCESS\n"
  echo
  echo
}

# 初始化

function init() {

  # docker-compose 是否安装

  which docker-compose

  if [ $? = 0 ];then
    #存在
    docker-compose --version

    echo -e "\033[32mINFO\033[0m  docker-compose already installed\n"

  else

    echo -e "\033[32mINFO\033[0m  docker-compose is installing...\n"

    # https://api.github.com/repos/docker/compose/releases/latest

    DOCKER_COMPOSE_VERSION=1.16.1

    curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose

    chmod +x docker-compose

    echo $PATH

    sudo mv docker-compose /usr/local/bin
  fi

  # 创建日志文件

  logs

  # 初始化完成提示

  echo -e "\033[32mINFO\033[0m  Init is SUCCESS please RUN  'docker-compose up -d' "
}

cleanup (){
  # 清理 images
  docker rmi lnmp-php \
             lnmp-laravel-artisan \
             lnmp-laravel \
             lnmp-postgresql \
             lnmp-mongo \
             lnmp-memcached \
             lnmp-mysql \
             lnmp-rabbitmq \
             lnmp-redis \
             lnmp-nginx

   # 清理日志文件
   logs

   echo -e "\033[32mINFO\033[0m  Clean is SUCCESS please RUN  './docker-lnmp init' "
}

case $1 in
  init )
    init
    ;;
  cleanup )
    cleanup
    ;;
  laravel )
    read -p "请输入路径: ./app/" path
    echo
    echo -e  "\033[32mINFO\033[0m  以下为输出内容\n\n"
    bin/laravel $path
    ;;
  artisan )
    read -p  "请输入路径: ./app/" path
    read -p  "请输入命令: php artisan " cmd
    echo
    echo -e  "\033[32mINFO\033[0m  以下为输出内容\n\n"
    bin/php-artisan $path $cmd
    ;;
  composer )
    read -p "请输入路径: ./app/" path
    read -p  "请输入命令: composer " cmd
    echo
    echo -e  "\033[32mINFO\033[0m  以下为输出内容\n\n"
    bin/composer $path $cmd
    ;;
  test )
    bin/test
    ;;
  * )
  echo  "
Docker-LNMP CLI "$VERSION"

USAGE: ./docker-lnmp COMMAND

Commands:
  init         初始化部署环境
  cleanup      清理已构建 docker images 、清理日志文件
  laravel      新建 Laravel 项目
  artisan      使用 Laravel 命令行工具 artisan
  composer     使用 Composer
  help         输出帮助信息
  test         开发者一键测试脚本

Read './docs/*.md' for more information on the command
"
;;
esac
