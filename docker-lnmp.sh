#!/bin/bash

VERSION=v17.09-rc3

DOCKER_COMPOSE_VERSION=1.16.1

ENV=$1

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

  # 不清理 Composer 缓存
  cd tmp
  if [ -d cache ];then
    echo -e "\n\033[32mINFO\033[0m  Composer cache nerver clean ,please human clean\n"
  else
    mkdir cache
    chmod 777 cache
  fi
  cd -

  echo -e "\n\033[32mINFO\033[0m  mkdir log folder SUCCESS\n"
  echo
  echo
}

# 是否安装 Docker Compose

install_docker_compose(){

    echo -e "\033[32mINFO\033[0m  docker-compose is installing...\n"

    # https://api.github.com/repos/docker/compose/releases/latest

    # DOCKER_COMPOSE_VERSION=1.16.1

    curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose

    chmod +x docker-compose

    echo $PATH

    sudo mv docker-compose /usr/local/bin
}

# 初始化

function init {
  if [ "$ENV" = "development" ];then
    echo "$ENV"
    git submodule update --init --recursive

    echo -e "\033[32mINFO\033[0m  Import app and nginx conf Demo ...\n"
    echo
  fi

  if [ "$ENV" = "production" ];then
    echo "$ENV"
    # 复制项目文件、配置文件
    echo -e "\033[32mINFO\033[0m  Copy app and nginx conf ...\n"
    # 安装 Composer 包
    # bin/composer-production test install
    echo
  fi
  # docker-compose 是否安装

  which docker-compose

  if [ $? = 0 ];then
    #存在
    docker-compose --version

    echo -e "\033[32mINFO\033[0m  docker-compose already installed\n"
    echo
  else
    install_docker_compose
  fi

  # 创建日志文件

  logs

  # 初始化完成提示

  echo -e "\033[32mINFO\033[0m  Init is SUCCESS please RUN  'docker-compose up -d' "
  echo
}

cleanup (){
  # 清理 images
  docker rmi lnmp-php \
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
    bin/laravel ${path}
    ;;

  artisan )
    read -p  "请输入路径: ./app/" path
    read -p  "请输入命令: php artisan " cmd
    echo
    echo -e  "\033[32mINFO\033[0m  以下为输出内容\n\n"
    bin/php-artisan ${path} ${cmd}
    ;;

  composer )
    read -p "请输入路径: ./app/" path
    read -p  "请输入命令: composer " cmd
    echo
    echo -e  "\033[32mINFO\033[0m  以下为输出内容\n\n"
    bin/composer ${path} ${cmd}
    ;;

  test )
    bin/test
    ;;

  production )
    init

    docker-compose \
         -f docker-compose.yml \
         -f docker-compose.prod.yml \
         up -d
    ;;

  production-down )
    docker-compose \
         -f docker-compose.yml \
         -f docker-compose.prod.yml \
         down
    ;;

  development )
    init

    docker-compose up -d
    ;;

  development-down )

    docker-compose down

    ;;

  * )
  echo  "
Docker-LNMP CLI ${VERSION}

USAGE: ./docker-lnmp COMMAND

Commands:
  init              初始化部署环境
  cleanup           清理已构建 docker images ，日志文件
  laravel           新建 Laravel 项目
  artisan           使用 Laravel 命令行工具 artisan
  composer          使用 Composer
  help              输出帮助信息
  development       LNMP 开发环境部署
  development-down  移除开发环境下的 LNMP Docker
  production        LNMP 生产环境部署
  production-down   移除生产环境下的 LNMP Docker
  test              生产环境一键测试脚本[开发者选项，普通用户请勿使用]

Read './docs/*.md' for more information on the command
"
;;
esac
