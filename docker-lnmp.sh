#!/bin/bash

VERSION=v17.09-rc3

# 构建单容器镜像

function build() {

  #statements

  docker images | grep lnmp

  docker rmi lnmp-laravel \
             lnmp-laravel-artisan

  # 构建单容器镜像

  cd dockerfile/laravel

  docker build -t lnmp-laravel .

  echo -e "\033[32mINFO\033[0m  Build lnmp-laravel Success\n"

  cd ../laravel-artisan

  docker build -t lnmp-laravel-artisan .

  echo -e "\033[32mINFO\033[0m  Build lnmp-laravel-artisan Success\n"

  docker images | grep lnmp
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

  echo -e "\033[32mINFO\033[0m  mkdir log folder\n"

  # 创建日志文件

  # rm -rf logs/*

  mkdir -p logs/mongodb
  cd logs/mongodb
  touch mongo.log
  cd -

  mkdir -p logs/mysql
  cd logs/mysql
  touch error.log
  cd -

  mkdir -p logs/nginx
  cd logs/nginx
  touch error.log access.log
  cd -

  mkdir -p logs/php-fpm
  cd logs/php-fpm
  touch error.log access.log xdebug-remote.log
  cd -

  mkdir -p logs/redis
  cd logs/redis
  touch redis.log
  cd -

  echo -e "\n\033[32mINFO\033[0m  mkdir log folder SUCCESS\n"

  # 构建单容器

  build

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
}

case $1 in
  init )
    init
    ;;
  build )
    build
    ;;
  cleanup )
    cleanup
    ;;
  * )
  echo  "
Docker-LNMP CLI "$VERSION"

USAGE: ./docker-lnmp COMMAND

Commands:
  init      : 初始化部署环境
  build     : 构建单容器镜像
  cleanup   : 清理环境
  help      : 输出帮助信息

Run './docker-lnmp COMMAND --help' for more information on the command
"
;;
esac
