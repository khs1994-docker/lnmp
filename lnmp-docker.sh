#!/bin/bash

ENV=$1
ARCH=`uname -m`
OS=`uname -s`

# 获取正确版本号

. env/.env

if [ ${OS} = "Darwin" ];then
  # 将以什么开头的行替换为新内容
  sed -i "" "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" .env
else
  sed -i "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" .env
fi

# 不支持信息

NOTSUPPORT(){
  echo -e "\033[32mINFO\033[0m  Not Support `uname -s` ${ARCH}\n"
  exit 1
}

# 创建日志文件

logs(){
  echo -e "\033[32mINFO\033[0m  mkdir log folder"
  cd logs
  if [ -d "mongodb" ];then
    echo -e "\033[32mINFO\033[0m  logs/mongodb existence"
  else
    mkdir mongodb && echo > mongodb/mongo.log \
    && echo -e "\033[32mINFO\033[0m  mkdir logs/mongod and touch log file"
   fi

  if [ -d "mysql" ];then
    echo -e "\033[32mINFO\033[0m  logs/mysql existence"
  else
    mkdir mysql && echo > mysql/error.log \
    && echo -e "\033[32mINFO\033[0m  mkdir logs/mysql and touch log file"
  fi

  if [ -d "nginx" ];then
    echo -e "\033[32mINFO\033[0m  logs/nginx existence"
  else
    mkdir nginx && echo > nginx/error.log && echo > nginx/access.log \
    && echo -e "\033[32mINFO\033[0m  mkdir logs/nginx and touch log file"
  fi

  if [ -d "php-fpm" ];then
    echo -e "\033[32mINFO\033[0m  logs/php-fpm existence"
  else
    mkdir php-fpm && echo > php-fpm/error.log && echo > php-fpm/access.log \
    && echo > php-fpm/xdebug-remote.log \
    && echo -e "\033[32mINFO\033[0m  mkdir logs/php-fpm and touch log file"
  fi

  if [ -d "redis" ];then
    echo -e "\033[32mINFO\033[0m  logs/redis existence"
  else
    mkdir redis && echo > redis/redis.log \
    && echo -e "\033[32mINFO\033[0m  mkdir logs/redis and touch log file"
  fi
  chmod -R 777 mongodb \
               mysql \
               nginx \
               php-fpm \
               redis

  cd ../

  # 不清理 Composer 缓存
  if [ -d "tmp/cache" ];then
    echo -e "\033[32mINFO\033[0m  Composer cache file existence"
  else
    mkdir -p tmp/cache && chmod 777 tmp/cache
    echo -e "\033[32mINFO\033[0m  mkdir tmp/cache"
  fi
  echo -e "\033[32mINFO\033[0m  mkdir log folder and file SUCCESS"
}

# 是否安装 Docker Compose

install_docker_compose(){
  command -v docker-compose >/dev/null 2>&1
  if [ $? = 0 ];then
    # 存在
    echo -e "\033[32mINFO\033[0m  `docker-compose --version` already installed"
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

# env

function env_status(){
  # .env.example to .env
  if [ -f .env ];then
    echo -e "\033[32mINFO\033[0m  .env existing\n"
  else
    echo -e "\033[31mINFO\033[0m  .env NOT existing\n"
    cp .env.example .env
    # exit 1
fi
}

# 初始化

function init {
  # docker-compose 是否安装
  install_docker_compose
  case $ENV in
    # 开发环境 拉取示例项目 [cn github]
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
  # 创建日志文件
  logs
  # 初始化完成提示
  echo -e "\033[32mINFO\033[0m  Init is SUCCESS\n"
}

# 清理日志文件

cleanup(){
   cd logs \
      && echo > mongodb/mongo.log \
      && echo > mysql/error.log \
      && echo > nginx/error.log \
      && echo > nginx/access.log \
      && echo > php-fpm/access.log \
      && echo > php-fpm/error.log \
      && echo > php-fpm/xdebug-remote.log \
      && echo > redis/redis.log \
      && echo -e "\n\033[32mINFO\033[0m  Clean log files SUCCESS\n"
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
  echo -e "\n\033[32mINFO\033[0m  ARCH is ${OS} ${ARCH}\n"
  env_status
  . .env
  . env/.env
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

  test )
    bin/test
    ;;

  commit )
    commit
    ;;

  laravel )
    read -p "请输入路径: ./app/" path
    bin/laravel ${path}
    ;;

  laravel-artisan )
    read -p  "请输入路径: ./app/" path
    read -p  "请输入命令: php artisan " cmd
    bin/php-artisan ${path} ${cmd}
    ;;

  composer )
    read -p "请输入路径: ./app/" path
    read -p  "请输入命令: composer " cmd
    bin/composer ${path} ${cmd}
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
    ;;

  development-build )
    if [ ${ARCH} = "x86_64" ];then
      docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d
    else
      NOTSUPPORT
    fi
    ;;

  development )
    init
    # 判断架构
    if [ ${ARCH} = "x86_64" ];then
      docker-compose up -d
    elif [ ${ARCH} = "armv7l" ];then
      if [ ! ${ARM_ARCH} ];then
        echo "ARM_ARCH=arm32v7" >> .env
      fi
        docker-compose -f docker-compose.arm.yml up -d
    elif [ ${ARCH} = "aarch64" ];then
      if [ ! ${ARM_ARCH} ];then
        echo "ARM_ARCH=arm64v8" >> .env
      fi
      docker-compose -f docker-compose.arm.yml up -d
    else
      NOTSUPPORT
    fi
    ;;

  development-config )
    # 判断架构
    if [ ${ARCH} = "x86_64" ];then
      docker-compose \
        -f docker-compose.yml \
        -f docker-compose.build.yml \
        config
    elif [ ${ARCH} = "armv7l" ];then
      if [ ! ${ARM_ARCH} ];then
        echo "ARM_ARCH=arm64v8" >> .env
      fi
      docker-compose \
        -f docker-compose.arm.yml \
        config
    elif [ ${ARCH} = "aarch64" ];then
      if [ ! ${ARM_ARCH} ];then
        echo "ARM_ARCH=arm64v8" >> .env
      fi
      docker-compose \
        -f docker-compose.arm.yml \
        config
    else
      NOTSUPPORT
    fi
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
    docker-compose exec mongodb bash
    ;;
  nginx-cli )
    docker-compose exec nginx sh
    ;;

  push )
    docker-compose \
      -f docker-compose.yml \
      -f docker-compose.push.yml \
      build \
    && docker-compose \
      -f docker-compose.yml \
      -f docker-compose.push.yml \
      push
    ;;

  push-config )
    docker-compose \
      -f docker-compose.yml \
      -f docker-compose.push.yml \
      config \
    ;;

  php )
    docker run -it --rm \
      -v $PWD/app/$2:/app/$2 \
      khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION} \
      php $3
   ;;

  down )
    docker-compose down --remove-orphans
    ;;

  * )
  echo  -e "
Docker-LNMP CLI ${KHS1994_LNMP_DOCKER_VERSION}

Usage: ./docker-lnmp.sh COMMAND

Commands:
  backup               Backup MySQL databases
  cleanup              Cleanup log files
  composer             Use PHP Package Management composer
  development          Use LNMP in Development(Support x86_64 arm32v7 arm64v8)
  development-config   Validate and view the Development(with build images) Compose file
  development-build    Use LNMP in Development With Build images(Support x86_64)
  down                 Stop and remove LNMP Docker containers, networks, images, and volumes
  help                 Display this help message
  laravel              Create a new Laravel application
  laravel-artisan      Use Laravel CLI artisan
  mysql-demo           Create MySQL test database
  php                  Run PHP in CLI
  production           Use LNMP in Production(Only Support Linux x86_64)
  production-config    Validate and view the Production Compose file
  push                 Build and Pushes images to Docker Registory v2
  restore              Restore MySQL databases

Container CLI:
  memcached-cli
  mongo-cli
  mysql-cli
  nginx-cli
  php-cli
  postgres-cli
  rabbitmq-cli
  redis-cli

Tools:
  update                Upgrades LNMP

Read './docs/*.md' for more information about commands.
"
    ;;
  esac
}

main $1 $2 $3 $4 $5 $6 $7 $8 $9
