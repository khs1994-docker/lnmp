#!/bin/bash

. .env

ENV=$1
ARCH=`uname -m`

# 创建日志文件

logs(){
  echo -e "\033[32mINFO\033[0m  mkdir log folder\n"

  if [ -d "logs/mongodb" ];then
    echo -e "\n\033[32mINFO\033[0m  logs/mongo existence\n"
  else
    mkdir -p logs/mongodb
    cd logs/mongodb
    touch mongo.log
    # 部分文件可能提示没有写入权限
    chmod 777 *
    cd -
   fi

  if [ -d "logs/mysql" ];then
    echo -e "\n\033[32mINFO\033[0m  logs/mysql existence\n"
  else
    mkdir -p logs/mysql
    cd logs/mysql
    echo > error.log
    echo -e "\n\033[32mINFO\033[0m  mkdir logs/mysql and touch log file\n"
    chmod 777 *
    cd -
  fi

  if [ -d "logs/nginx" ];then
    echo -e "\n\033[32mINFO\033[0m  logs/nginx existence\n"
  else
    mkdir -p logs/nginx
    cd logs/nginx
    echo > error.log
    echo > access.log
    chmod 777 *
    echo -e "\n\033[32mINFO\033[0m  mkdir logs/nginx and touch log file\n"
    cd -
  fi

  if [ -d "logs/php-fpm" ];then
    echo -e "\n\033[32mINFO\033[0m  logs/php-fpm existence\n"
  else
    mkdir -p logs/php-fpm
    cd logs/php-fpm
    echo > error.log
    echo > access.log
    echo > xdebug-remote.log
    chmod 777 *
    echo -e "\n\033[32mINFO\033[0m  mkdir logs/php-fpm and touch log file\n"
    cd -
  fi

  if [ -d "logs/redis" ];then
    echo -e "\n\033[32mINFO\033[0m  logs/redis existence\n"
  else
    mkdir -p logs/redis
    cd logs/redis
    echo > redis.log
    chmod 777 *
    echo -e "\n\033[32mINFO\033[0m  mkdir logs/redis and touch log file\n"
    cd -
  fi

  # 不清理 Composer 缓存
  cd tmp
  if [ -d cache ];then
    echo -e "\n\033[32mINFO\033[0m  Composer cache existence\n"
  else
    mkdir cache
    chmod 777 cache
    echo -e "\n\033[32mINFO\033[0m  mkdir ./tmp/cache\n"
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
    if [ `uname -s` = "linux"  ${ARCH} = "x86_64" ];then
      echo -e "\033[32mINFO\033[0m  cn docker-compose is installing...\n"
      cd bin/compose
      git fetch origin
      git reset --hard origin/master
      chmod +x docker-compose
      . /etc/os-release
      if [ `echo $ID` = "coreos" ];then
        # 如果是 CoreOS 移动到 /opt/bin
        sudo mv docker-compose-`uname -s`-${ARCH} /opt/bin/docker-compose
      else
        sudo mv docker-compose-`uname -s`-${ARCH} /usr/local/bin/docker-compose
      fi
      cd - && pwd
    else
      echo -e "\033[32mINFO\033[0m  `uname -s` ${ARCH} 暂不支持自动安装，请使用执行 pip install docker-compose\n"
    fi
  fi
}

install_docker_compose(){
  command -v docker-compose >/dev/null 2>&1
  if [ $? = 0 ];then
    #存在
    docker-compose --version
    echo -e "\033[32mINFO\033[0m  docker-compose already installed\n"
    echo
  else
    echo -e "\033[32mINFO\033[0m  docker-compose is installing...\n"
    # 版本在 .env 文件定义
    # https://api.github.com/repos/docker/compose/releases/latest
    curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
    chmod +x docker-compose
    echo $PATH
    sudo mv docker-compose /usr/local/bin
    install_docker_compose
  fi
}

function mysql_demo {
  docker-compose exec mysql /backup/demo.sh
}

# 克隆示例项目
function demo {
  #statements
  echo -e "\033[32mINFO\033[0m  Import app and nginx conf Demo ...\n"
  git submodule update --init --recursive
  echo
  echo
}

# 初始化

function init {
  # 开发环境 拉取示例项目
  # cn github
  case $ENV in
    development )
      echo "$ENV"
      demo
      ;;

  # 生产环境 转移项目文件、配置文件、安装依赖包
    production )
      echo "$ENV"
      # 请在 ./bin/production-init 定义要执行的操作
      bin/production-init
      ;;

    arm32v7 )
      demo
      ;;

    arm32v8 )
      demo
      ;;
  esac
  # docker-compose 是否安装

  install_docker_compose

  # 创建日志文件

  logs

  # 初始化完成提示

  echo -e "\033[32mINFO\033[0m  Init is SUCCESS\n"
  echo
  echo
}

cleanup(){
  # 清理 images
  # docker rmi lnmp-php \
  #            lnmp-postgresql \
  #            lnmp-mongo \
  #            lnmp-memcached \
  #            lnmp-mysql \
  #            lnmp-rabbitmq \
  #            lnmp-redis \
  #            lnmp-nginx
  # 不自动清理，列出镜像，用户自己清理
  docker images | grep "lnmp"
  docker images | grep "khs1994"

   # 清理日志文件
   cd logs
   rm -rf mongodb \
           mysql \
           nginx \
           php-fpm \
           redis

   # 建立空白日志文件夹及文件
   logs
   echo -e "\033[32mINFO\033[0m  Clean SUCCESS and recreate log file\n"
}

backup(){
  docker-compose exec mysql /backup/backup.sh
}

restore(){
  docker-compose exec mysql /backup/restore.sh
}

update(){
  git fetch origin
  BRANCH=`git rev-parse --abbrev-ref HEAD`
  if [ ${BRANCH} = `dev` ];then
    git reset --hard origin/dev
  else
    git checkout dev
    git reset --hard origin/dev
  fi
}

commit(){
  git add .
  git commit -m "Update [skip ci]"
}

main() {
  echo -e "${ARCH}\n"
  case $1 in
  compose )
    install_docker_compose_cn
    ;;

  init )
    init
    echo -e "\n${ARCH}\n"
    ;;

  demo )
    demo
    echo -e "\n${ARCH}\n"
    ;;

  cleanup )
    cleanup
    echo -e "\n${ARCH}\n"
    ;;

  test )
    bin/test
    echo -e "\n${ARCH}\n"
    ;;
    
  commit )
    commit
    ;;

  laravel )
    read -p "请输入路径: ./app/" path
    echo
    echo -e  "\033[32mINFO\033[0m  在容器内 /app/${path} 执行 laravel new ${path}"
    echo
    echo -e  "\033[32mINFO\033[0m  以下为输出内容\n\n"
    if [ ${ARCH} = "x86_64" ];then
      bin/laravel ${path}
    else
      bin/arm32v7/laravel ${path}
    fi
    echo -e "\n${ARCH}\n"
    ;;

  artisan )
    read -p  "请输入路径: ./app/" path
    read -p  "请输入命令: php artisan " cmd
    echo
    echo -e  "\033[32mINFO\033[0m  在容器内 /app/${path} 执行 php artisan ${cmd}"
    echo
    echo -e  "\033[32mINFO\033[0m  以下为输出内容\n\n"
    if [ ${ARCH} = "x86_64" ];then
      bin/php-artisan ${path} ${cmd}
    else
      bin/arm32v7/php-artisan ${path} ${cmd}
    fi
    echo -e "\n${ARCH}\n"
    ;;

  composer )
    read -p "请输入路径: ./app/" path
    read -p  "请输入命令: composer " cmd
    echo
    echo -e  "\033[32mINFO\033[0m  在容器内 /app/${path} 执行 composer ${cmd}"
    echo
    echo -e  "\033[32mINFO\033[0m  以下为输出内容\n\n"
    if [ ${ARCH} = "x86_64" ];then
      bin/composer ${path} ${cmd}
    else
      bin/arm32v7/composer ${path} ${cmd}
    fi
    echo -e "\n${ARCH}\n"
    ;;

  production )
    init

    docker-compose \
         -f docker-compose.yml \
         -f docker-compose.prod.yml \
         up -d
    echo -e "\n${ARCH}\n"
    ;;


  production-config )
    docker-compose \
         -f docker-compose.yml \
         -f docker-compose.prod.yml \
         config
    echo -e "\n${ARCH}\n"
    ;;

  development )
    init
    # 判断架构
    if [ ${ARCH} = "x86_64" ];then
      case $2 in
        --build )
          docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d
          ;;
        * )
          docker-compose up -d
          ;;
      esac
    elif [ ${ARCH} = "armv7l" ];then
      docker-compose -f docker-compose.arm32v7.yml up -d
    else
      echo -e "\033[32mINFO\033[0m  arm64v8 暂不支持\n"
    fi
    echo -e "\n${ARCH}\n"
    ;;

  development-config )
    # 判断架构
    if [ ${ARCH} = "x86_64" ];then
      docker-compose -f docker-compose.yml -f docker-compose.build.yml config
    elif [ ${ARCH} = "armv7l" ];then
      docker-compose -f docker-compose.arm32v7.yml config
    else
      echo -e "\033[32mINFO\033[0m  ${ARCH} 暂不支持\n"
    fi
    echo -e "\n${ARCH}\n"
    ;;

  backup )
    backup
    ;;

  restore )
    restore
    ;;

  mysql-demo )
    mysql_demo
    ;;

  update )
    update
    ;;

  * )
  echo  -e "
Docker-LNMP CLI ${KHS1994_LNMP_DOCKER_VERSION} `uname -s` ${ARCH}

USAGE: ./docker-lnmp COMMAND

Commands:
  compose              国内用户安装 docker-compose (Linux X86_64)
  cleanup              清理日志文件
  demo                 克隆示例项目、配置文件
  mysql-demo           创建示例 MySQL 数据库
  init                 初始化部署环境
  laravel              新建 Laravel 项目
  artisan              使用 Laravel 命令行工具 artisan
  composer             使用 Composer
  development          LNMP 开发环境部署（支持 x86_64 arm32v7 arm64v8 架构）
  development --build  LNMP 开发环境部署--构建镜像（支持 x86_64 ）
  production           LNMP 生产环境部署（支持 x86_64 ）
  backup               备份数据库
  restore              恢复数据库
  update               更新项目到最新版
  help                 输出帮助信息
  test                 生产环境一键测试脚本[开发者选项]
  commit               提交项目[开发者选项]


Read './docs/*.md' for more information on the command
"
    ;;
  esac
}
main $1 $2
