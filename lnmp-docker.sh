#!/bin/bash

. .env

ENV=$1
ARCH=`uname -m`

# 不支持信息

NOTSUPPORT(){
  echo -e "\033[32mINFO\033[0m `uname -s` ${ARCH} 暂不支持\n"
}

# 创建日志文件

logs(){
  echo -e "\033[32mINFO\033[0m  mkdir log folder"

  if [ -d "logs/mongodb" ];then
    echo -e "\033[32mINFO\033[0m  logs/mongo existence"
  else
    mkdir -p logs/mongodb && cd logs/mongodb && echo > mongo.log && chmod 777 *
    echo -e "\033[32mINFO\033[0m  mkdir logs/mongod and touch log file"
    cd -
   fi

  if [ -d "logs/mysql" ];then
    echo -e "\033[32mINFO\033[0m  logs/mysql existence"
  else
    mkdir -p logs/mysql && cd logs/mysql && echo > error.log && chmod 777 *
    echo -e "\033[32mINFO\033[0m  mkdir logs/mysql and touch log file"
    cd -
  fi

  if [ -d "logs/nginx" ];then
    echo -e "\033[32mINFO\033[0m  logs/nginx existence"
  else
    mkdir -p logs/nginx && cd logs/nginx && echo > error.log && echo > access.log && chmod 777 *
    echo -e "\033[32mINFO\033[0m  mkdir logs/nginx and touch log file"
    cd -
  fi

  if [ -d "logs/php-fpm" ];then
    echo -e "\033[32mINFO\033[0m  logs/php-fpm existence"
  else
    mkdir -p logs/php-fpm && cd logs/php-fpm && echo > error.log && echo > access.log && echo > xdebug-remote.log && chmod 777 *
    echo -e "\033[32mINFO\033[0m  mkdir logs/php-fpm and touch log file"
    cd -
  fi

  if [ -d "logs/redis" ];then
    echo -e "\033[32mINFO\033[0m  logs/redis existence"
  else
    mkdir -p logs/redis && cd logs/redis && echo > redis.log && chmod 777 *
    echo -e "\033[32mINFO\033[0m  mkdir logs/redis and touch log file"
    cd -
  fi
  # 不清理 Composer 缓存
  if [ -d "tmp/cache" ];then
    echo -e "\033[32mINFO\033[0m  Composer cache existence"
  else
    cd tmp && mkdir cache && chmod 777 cache && cd -
    echo -e "\033[32mINFO\033[0m  mkdir tmp/cache"
  fi
  pwd && echo -e "\033[32mINFO\033[0m  mkdir log folder SUCCESS\n"
}

# 是否安装 Docker Compose

install_docker_compose(){
  command -v docker-compose >/dev/null 2>&1
  if [ $? = 0 ];then
    # 存在
    echo -e "\033[32mINFO\033[0m  docker-compose already installed\n"
    docker-compose --version
  else
    # 不存在
    echo -e "\033[32mINFO\033[0m  docker-compose is installing ...\n"
    if [ ${ARCH} = "armv7l" -o ${ARCH} = "aarch64" ];then
      #arm
      echo -e "\033[32mINFO\033[0m  ${ARCH} docker-compose is installing by pip3 ...\n"
      sudo apt install -y python3-pip
      # pip 源
      if [ !-d "~/.pip"];then
        mkdir -p ~/.pip
        echo -e "[global]\nindex-url = https://pypi.douban.com/simple\n[list]\nformat=columns" > ~/.pip/pip.conf
      fi
      sudo pip3 install docker-compose
    elif [ `uanme -s` = "Linux" -o `uname -s` = "Darwin" ];then
      # 版本在 .env 文件定义
      # https://api.github.com/repos/docker/compose/releases/latest
      # Linux macOS
      curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
      chmod +x docker-compose
      echo $PATH && sudo mv docker-compose /usr/local/bin
    else
      NOTSUPPORT
    fi
  fi
  echo
}

# 创建示例数据库

function mysql_demo {
  docker-compose exec mysql /backup/demo.sh
}

# 克隆示例项目、nginx 配置文件

function demo {
  #statements
  echo -e "\033[32mINFO\033[0m  Import app and nginx conf Demo ...\n"
  git submodule update --init --recursive
}

# 初始化

function init {
  # 开发环境 拉取示例项目 [cn github]
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
  esac
  # docker-compose 是否安装
  install_docker_compose
  # 创建日志文件
  logs
  # 初始化完成提示
  echo -e "\033[32mINFO\033[0m  Init is SUCCESS\n"
}

# 清理日志文件

cleanup(){
  docker images | grep "lnmp"
  docker images | grep "khs1994"

  # 清理日志文件
   cd logs
   rm -rf mongodb \
           mysql \
           nginx \
           php-fpm \
           redis \
      && cd - && logs && echo -e "\033[32mINFO\033[0m  Clean SUCCESS and recreate log file\n"
}

# 备份数据库

backup(){
  docker-compose exec mysql /backup/backup.sh $@
}

# 恢复数据库

restore(){
  docker-compose exec mysql /backup/restore.sh $1
}

# 更新项目

update(){
  git fetch origin
  BRANCH=`git rev-parse --abbrev-ref HEAD`
  echo -e "\n\033[32mINFO\033[0m  Branch is ${BRANCH}\n"
  if [ ${BRANCH} = "dev" ];then
    git reset --hard origin/dev
  elif [ ${BRANCH} = "master" ];then
    git reset --hard origin/master
  else
    git checkout dev && git reset --hard origin/dev
  fi
}

# 提交项目「开发者选项」

commit(){
  BRANCH=`git rev-parse --abbrev-ref HEAD`
  echo -e "\n\033[32mINFO\033[0m  Branch is ${BRANCH}\n"
  if [ ${BRANCH} = "dev" ];then
    git add .
    git commit -m "Update [skip ci]"
    git push origin dev
  else
    echo -e "\n\033[32mINFO\033[0m  ${BRANCH} 分支不能自动提交\n"
  fi
}

# 入口文件

main() {
  echo -e "${ARCH}\n"
  case $1 in

  init )
    init && echo -e "${ARCH}"
    ;;

  demo )
    demo && echo -e "${ARCH}"
    ;;

  cleanup )
    cleanup && echo -e "${ARCH}"
    ;;

  test )
    bin/test && echo -e "${ARCH}"
    ;;

  commit )
    commit
    ;;

  laravel )
    read -p "请输入路径: ./app/" path
    bin/laravel ${path} && echo -e "\n${ARCH}"
    ;;

  artisan )
    read -p  "请输入路径: ./app/" path
    read -p  "请输入命令: php artisan " cmd
    bin/php-artisan ${path} ${cmd} && echo -e "\n${ARCH}"
    ;;

  composer )
    read -p "请输入路径: ./app/" path
    read -p  "请输入命令: composer " cmd
    bin/composer ${path} ${cmd} && echo -e "\n${ARCH}"
    ;;

  production )
    # 仅允许运行在 Linux x86_64
    if [ `uname -s` = "Linux" -a ${ARCH} = "x86_64" ];then
      init
      docker-compose \
         -f docker-compose.yml \
         -f docker-compose.prod.yml \
         up -d
      echo -e "${ARCH}"
    else
      echo -e "\033[32mINFO\033[0m  生产环境不支持 `uname -s` ${ARCH}\n"
    fi
    ;;

  production-config )
    docker-compose \
         -f docker-compose.yml \
         -f docker-compose.prod.yml \
         config
    echo -e "${ARCH}"
    ;;

  ci )
    cd ci
    if [ -f ".env" -a -f ".update.js" ];then
      docker-compose up -d
    else
      echo -e "\033[32mINFO\033[0m  自定义 .env .update.js 之后再运行 $ ci/init.sh \n"
    fi
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
    elif [ ${ARCH} = "aarch64" ];then
      docker-compose -f docker-compose.arm64v8.yml up -d
    else
      NOTSUPPORT
    fi
    echo -e "${ARCH}"
    ;;

  development-config )
    # 判断架构
    if [ ${ARCH} = "x86_64" ];then
      docker-compose -f docker-compose.yml -f docker-compose.build.yml config
    elif [ ${ARCH} = "armv7l" ];then
      docker-compose -f docker-compose.arm32v7.yml config
    elif [ ${ARCH} = "aarch64" ];then
      docker-compose -f docker-compose.arm64v8.yml config
    else
      NOTSUPPORT
    fi
    echo -e "${ARCH}"
    ;;

  backup )
    backup $2 $3 $4 $5 $6 $7 $8 $9
    ;;

  restore )
    restore $2
    ;;

  mysql-demo )
    mysql_demo
    ;;

  update )
    update
    ;;

  mysql-cli )
    docker-compose exec mysql mysql -uroot -p${MYSQL_ROOT_PASSWORD}
    ;;

  php-cli )
    docker-compose exec php7 bash
    ;;

  redis-cli )
    docker-compose exec redis sh
    ;;
  memcached-cli )
    docker-compose exec memcached sh
    ;;
  rabbitmq-cli )
    docker-compose exec rabbitmq sh
    ;;
  postgres-cli )
    docker-compose exec postgresql sh
    ;;
  mongo-cli )
    docker-compose exec mongo bash
    ;;
  nginx-cli )
    docker-compose exec nginx sh
    ;;

  push )
    docker-compose -f docker-compose.yml -f docker-compose.push.yml build \
      && docker-compose -f docker-compose.yml -f docker-compose.push.yml push
    ;;

  php )
    cd app
    echo "version: \"3.3\"
services:

  php:
    image: khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine
    volumes:
      - ./$2:/app
    command: [\"php\",\"$3\"]
" > docker-compose.yml

    docker-compose up && docker-compose down
   ;;

  * )
  echo  -e "
Docker-LNMP CLI ${KHS1994_LNMP_DOCKER_VERSION} `uname -s` ${ARCH}

USAGE: ./docker-lnmp COMMAND

Commands:
  init                 初始化部署环境
  cleanup              清理日志文件
  demo                 克隆 nginx 配置文件
  mysql-demo           创建示例 MySQL 数据库
  php                  命令行执行 PHP 文件「相对于 ./app 的路径 PHP文件名」
  mysql-cli | php-cli | redis-cli | memcached-cli | rabbitmq-cli | postgres-cli | mongo-cli | nginx-cli
  laravel              新建 Laravel 项目
  artisan              使用 Laravel 命令行工具 artisan
  composer             使用 Composer
  development          LNMP 开发环境部署（支持 x86_64 arm32v7 arm64v8 架构）
  development-config   调试开发环境 Docker Compose 配置
  development --build  LNMP 开发环境部署--构建镜像（支持 x86_64 ）
  production           LNMP 生产环境部署（仅支持 Linux x86_64 ）
  production-config    调试生产环境 Docker Compose 配置
  ci                   生产环境自动更新项目为最新
  push                 构建 Docker 镜像并推送到 Docker 私有仓库，以用于生产环境
  backup               备份 MySQL 数据库「加参数」
  restore              恢复 MySQL 数据库「加 SQL 文件名」
  update               更新项目到最新版
  help                 输出帮助信息
  test                 「开发者选项」生产环境一键测试脚本
  commit               「开发者选项」提交项目


Read './docs/*.md' for more information on the command
"
    ;;
  esac
}

main $1 $2 $3 $4 $5 $6 $7 $8 $9
