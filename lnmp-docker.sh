#!/bin/bash

VERSION=v17.09-rc4

DOCKER_COMPOSE_VERSION=1.16.1

ENV=$1

logs(){
  # 创建日志文件

  echo -e "\033[32mINFO\033[0m  mkdir log folder\n"

  cd logs

#  rm -rf mongodb \
#         mysql \
#         nginx \
#         php-fpm \
#         redis
  cd -

  if [ -d "logs/mongodb" ];then
    echo
  else
    mkdir -p logs/mongodb
    cd logs/mongodb
    touch mongo.log
    # 部分文件可能提示没有写入权限

    chmod 777 *
    cd -
   fi

  if [ -d "logs/mysql" ];then
    echo
  else
    mkdir -p logs/mysql
    cd logs/mysql
    echo > error.log
    chmod 777 *
    cd -
  fi

  if [ -d "logs/nginx" ];then
    echo
  else
    mkdir -p logs/nginx
    cd logs/nginx
    echo > error.log
    echo > access.log
    chmod 777 *
    cd -
  fi

  if [ -d "logs/php-fpm" ];then
    echo
  else
    mkdir -p logs/php-fpm
    cd logs/php-fpm
    echo > error.log
    echo > access.log
    echo > xdebug-remote.log
    chmod 777 *
    cd -
  fi

  if [ -d "logs/redis" ];then
    echo
  else
    mkdir -p logs/redis
    cd logs/redis
    echo > redis.log
    chmod 777 *
    cd -
  fi

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
# cn
install_docker_compose_cn(){
  # 判断是否安装
  command -v docker-compose >/dev/null 2>&1
  if [ $? = 0 ];then
    #存在
    docker-compose --version
    echo -e "\033[32mINFO\033[0m  docker-compose already installed\n"
    echo

  else

    echo -e "\033[32mINFO\033[0m  cn docker-compose is installing...\n"

    if [ -f "docker-compose" ];then
      # 是否存在文件
      # Thanks Aliyun CODE
      # 判断操作系统
      chmod +x docker-compose
      echo $PATH
      sudo mv docker-compose /usr/local/bin
      else
        # 命令行下载不了，请自行下载
        echo -e "使用浏览器打开\nhttps://code.aliyun.com/khs1994-docker/compose-cn-mirror/tags/${DOCKER_COMPOSE_VERSION}\n进行下载，并改名为 ' docker-compose ' "
    fi
  fi
}

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

function demo {
  #statements
  echo "$ENV"
  git submodule update --init --recursive

  echo -e "\033[32mINFO\033[0m  Import app and nginx conf Demo ...\n"
  echo
}

function init {
  # 开发环境 拉取示例项目
  # cn github
  case $ENV in
    development )
    demo
    ;;

  # 生产环境 转移项目文件、配置文件、安装依赖包
  production )
    echo "$ENV"
    # 复制项目文件、配置文件
    echo -e "\033[32mINFO\033[0m  Copy app and nginx conf ...\n"
    # 安装 Composer 包
    # bin/composer-production test install
    echo
    ;;

  arm32v7 )
    demo
    ;;

  arm32v8 )
    demo
    ;;

  esac
  # docker-compose 是否安装
  # which docker-compose

  command -v docker-compose >/dev/null 2>&1

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

  demo )
    demo
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

  compose )
    install_docker_compose_cn
    ;;
  arm32v7 )
    init
    docker-compose -f docker-compose.arm32v7.yml up -d
    ;;
  arm32v7-down )
    docker-compose -f docker-compose.arm32v7.yml down
    ;;
  arm64v8 )
    # docker-compose -f docker-compose.arm64v8.yml up -d
    ;;
  arm64v8-down )
    # docker-compose -f docker-compose.arm64v8.yml down
    ;;
  * )
  echo  "
Docker-LNMP CLI ${VERSION}

USAGE: ./docker-lnmp COMMAND

Commands:
  compose             安装 docker-compose (针对国内用户)
  init                初始化部署环境
  demo                克隆示例项目、配置文件
  cleanup             清理已构建 docker images ，日志文件
  laravel             新建 Laravel 项目
  artisan             使用 Laravel 命令行工具 artisan
  composer            使用 Composer
  help                输出帮助信息
  development         LNMP 开发环境部署
  development-down    移除开发环境下的 LNMP Docker
  production          LNMP 生产环境部署
  production-down     移除生产环境下的 LNMP Docker
  test                生产环境一键测试脚本[开发者选项，普通用户请勿使用]

Read './docs/*.md' for more information on the command
"
;;
esac
