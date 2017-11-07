#!/bin/bash

if [ ! -z $1 ];then
  if [ $1 = "development" -o $1 = "production" ];then
    APP_ENV=$1
  fi
fi

# env
function print_info(){
  echo -e "\033[32mINFO\033[0m  $1"
}

function print_error(){
  echo -e "\033[31mINFO\033[0m  $1"
}

function env_status(){
  # .env.example to .env
  if [ -f .env ];then
    print_info ".env existing\n"
  else
    print_error ".env NOT existing\n"
    cp .env.example .env
    # exit 1
  fi
}

env_status
ARCH=`uname -m`
OS=`uname -s`
BRANCH=`git rev-parse --abbrev-ref HEAD`
COMPOSE_LINK_OFFICIAL=https://github.com/docker/compose/releases/download/
COMPOSE_LINK=https://code.aliyun.com/khs1994-docker/compose-cn-mirror/raw/exec/
# COMPOSE_LINK=https://gitee.com/khs1994/compose-cn-mirror/raw/exec/
# COMPOSE_LINK=https://git.cloud.tencent.com/khs1994-docker/compose-cn-mirror/raw/exec/

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
  print_error "Not Support `uname -s` ${ARCH}\n"
  exit 1
}

# 创建日志文件

logs(){
  if [ ! -d "logs/mongodb" ];then mkdir -p logs/mongodb && echo > logs/mongodb/mongo.log; fi

  if [ ! -d "logs/mysql" ];then mkdir -p logs/mysql && echo > logs/mysql/error.log; fi

  if [ ! -d "logs/nginx" ];then mkdir -p logs/nginx && echo > logs/nginx/error.log && echo > logs/nginx/access.log; fi

  if [ ! -d "logs/php-fpm" ];then
    mkdir -p logs/php-fpm && echo > logs/php-fpm/error.log \
      && echo > logs/php-fpm/access.log \
      && echo > logs/php-fpm/xdebug-remote.log
  fi

  if [ ! -d "logs/redis" ];then mkdir -p logs/redis && echo > logs/redis/redis.log ; fi
  chmod -R 777 logs/mongodb \
               logs/mysql \
               logs/nginx \
               logs/php-fpm \
               logs/redis

  # 不清理 Composer 缓存
  if [ ! -d "tmp/cache" ];then mkdir -p tmp/cache && chmod 777 tmp/cache; fi
}

# 清理日志文件

cleanup(){
      logs \
      && echo > logs/mongodb/mongo.log \
      && echo > logs/mysql/error.log \
      && echo > logs/nginx/error.log \
      && echo > logs/nginx/access.log \
      && echo > logs/php-fpm/access.log \
      && echo > logs/php-fpm/error.log \
      && echo > logs/php-fpm/xdebug-remote.log \
      && echo > logs/redis/redis.log
      print_info "Clean log files SUCCESS\n"
}

gitbook(){
  docker run -it --rm \
    -p 4000:4000 \
    -v $PWD/docs:/tmp/gitbook-src \
    khs1994/gitbook \
    server
}

dockerfile-update-sed(){
  sed -i '' 's/^FROM.*/'"${2}"'/g' dockerfile/$1/Dockerfile
  sed -i '' 's/^TAG.*/TAG='"${3}"'/g' dockerfile/$1/.env
  git diff
}

dockerfile-update(){
  read -p "Soft is: " SOFT
  read -p "Version is: " VERSION
  case $SOFT in
    memcached )
      dockerfile-update-sed $SOFT "FROM $SOFT-$VERSION-alpine" $VERSION
      sed -i '' 's/^KHS1994_LNMP_MEMCACHED_VERSION.*/KHS1994_LNMP_MEMCACHED_VERSION='"${VERSION}"'/g' .env.example .env.travis
      sed -i '' 's/^KHS1994_LNMP_MEMCACHED_VERSION.*/KHS1994_LNMP_MEMCACHED_VERSION='"${VERSION}"'/g' .env.travis
    ;;
    nginx )
      dockerfile-update-sed $SOFT "FROM $SOFT-$VERSION-alpine" $VERSION
    ;;
    php-fpm )
      dockerfile-update-sed $SOFT "FROM $SOFT-$VERSION-alpine" $VERSION
    ;;
    postgresql )
      dockerfile-update-sed $SOFT "FROM $SOFT-$VERSION-alpine" $VERSION
    ;;
    rabbitmq )
      dockerfile-update-sed $SOFT "FROM $SOFT-$VERSION-management-alpine" $VERSION
      sed -i '' 's/^KHS1994_LNMP_RABBITMQ_VERSION.*/KHS1994_LNMP_RABBITMQ_VERSION='"${VERSION}"'/g' .env.example .env.travis
      sed -i '' 's/^KHS1994_LNMP_RABBITMQ_VERSION.*/KHS1994_LNMP_RABBITMQ_VERSION='"${VERSION}"'/g' .env.travis
    ;;
    redis )
      dockerfile-update-sed $SOFT "FROM $SOFT-$VERSION-alpine" $VERSION
    ;;
    * )
    print_error "Soft is not existing"
    dockerfile-update
  esac
}

# 是否安装 Docker Compose

install_docker_compose_official(){
  # 版本在 env/.env 文件定义
  # https://api.github.com/repos/docker/compose/releases/latest
  curl -L ${COMPOSE_LINK_OFFICIAL}${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
  chmod +x docker-compose
  echo $PATH && sudo mv docker-compose /usr/local/bin
  # in CoreOS you must move to /opt/bin
}

install_docker_compose(){
  command -v docker-compose >/dev/null 2>&1
  if [ $? = 0 ];then
    # 存在
    print_info "`docker-compose --version` already installed"
  else
    # 不存在
    print_info "docker-compose is installing ...\n"
    if [ ${ARCH} = "armv7l" -o ${ARCH} = "aarch64" ];then
      #arm
      print_info "${ARCH} docker-compose is installing by pip3 ...\n"
      sudo apt install -y python3-pip
      # pip 源
      if [ !-d "~/.pip" ];then
        mkdir -p ~/.pip
        echo -e "[global]\nindex-url = https://pypi.douban.com/simple\n[list]\nformat=columns" > ~/.pip/pip.conf
      fi
      sudo pip3 install docker-compose
    elif [ $OS = "Linux" -o $OS = "Darwin" ];then
      curl -L ${COMPOSE_LINK}docker-compose-`uname -s`-`uname -m` -o docker-compose
      chmod +x docker-compose
      if [ -f  "/etc/os-release" ];then
        # linux
        . /etc/os-release
        case $ID in
          coreos )
            if [ ! -d "/opt/bin" ];then sudo mkdir -p /opt/bin; fi
            sudo cp -a docker-compose /opt/bin/docker-compose
            ;;
          * )
            sudo cp -a docker-compose /usr/local/bin/docker-compose
            ;;
        esac
      else
          # macOS
          sudo cp -a docker-compose /usr/local/bin/docker-compose
      fi
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
  print_info "Import app and nginx conf Demo ...\n"
  git submodule update --init --recursive
}

# 初始化

function init {
  # docker-compose 是否安装
  install_docker_compose
  case $APP_ENV in
    # 开发环境 拉取示例项目 [cn github]
    development )
      print_info "$APP_ENV"
      demo
      ;;

    # 生产环境 转移项目文件、配置文件、安装依赖包
    production )
      print_info "$APP_ENV"
      # 请在 ./bin/production-init 定义要执行的操作
      bin/production-init
      ;;
  esac
  # 初始化完成提示
  print_info "Init is SUCCESS\n"
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
  print_info "Branch is ${BRANCH}\n"
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
  print_info "Branch is ${BRANCH}\n"
  if [ ${BRANCH} = "dev" ];then
    git add .
    git commit -m "Update [skip ci]"
    git push origin dev
  else
    print_error "${BRANCH} 分支不能自动提交\n"
  fi
}

release_rc(){
  print_info "开始新的 RC 版本开发"
  print_info "Branch is ${BRANCH}\n"
  if [ ${BRANCH} = "dev" ];then
    git fetch origin
    git reset --hard origin/master
    git push -f origin dev
  else
    print_error "${BRANCH} 分支不能自动提交\n"
  fi
}

# 入口文件

main() {
  # 创建日志文件夹
  logs
  # no sudo
  # if [[ $EUID -eq 0 ]]; then print_error "This script should not be run using sudo!!\n"; exit 1; fi
  # 架构
  print_info "ARCH is ${OS} ${ARCH}\n"
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
  rc )
    release_rc
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
    else
      print_error "生产环境不支持 `uname -s` ${ARCH}\n"
    fi
    ;;

  production-config )
    init
    docker-compose \
         -f docker-compose.yml \
         -f docker-compose.prod.yml \
         config
    ;;

  development-build )
    init
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
    init
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
    init
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
    init
    docker-compose \
      -f docker-compose.yml \
      -f docker-compose.push.yml \
      config \
    ;;

  php )
    if [ $ARCH="x86_64" ];then
      PHP_CLI_DOCKER_IMAGE=php-fpm
      PHP_CLI_DOCKER_TAG=${KHS1994_LNMP_PHP_VERSION}-alpine3.4
    elif [ $ARCH="armv7l" ];then
      PHP_CLI_DOCKER_IMAGE=arm32v7-php-fpm
      PHP_CLI_DOCKER_TAG=${KHS1994_LNMP_PHP_VERSION}-jessie
    elif [ $ARCH="aarch64" ];then
      PHP_CLI_DOCKER_IMAGE=arm64v8-php-fpm
      PHP_CLI_DOCKER_TAG=${KHS1994_LNMP_PHP_VERSION}-jessie
    else
      NOTSUPPORT
    fi
    docker run -it --rm \
      -v $PWD/app/$2:/app \
      khs1994/${PHP_CLI_DOCKER_IMAGE}:${PHP_CLI_DOCKER_TAG} \
      php $3
   ;;

  down )
    init
    docker-compose down --remove-orphans
    ;;
  docs )
    gitbook
    ;;

  test-image )
    init
    docker-compose \
      -f docker-compose.test.yml \
      up -d
    ;;
  test-image-down )
    docker-compose \
      -f docker-compose.test.yml \
      down
    ;;
  dockerfile-update )
    dockerfile-update
    ;;
  swarm )
    docker stack deploy \
      -c docker-compose.swarm.yml \
      lnmp
    docker stack ps lnmp
    ;;

  swarm-down )
    docker stack rm lnmp
    ;;

  * )
  echo  -e "
Docker-LNMP CLI ${KHS1994_LNMP_DOCKER_VERSION}

Official WebSite https://lnmp.khs1994.com

Usage: ./docker-lnmp.sh COMMAND

Commands:
  backup               Backup MySQL databases
  cleanup              Cleanup log files
  composer             Use PHP Package Management composer
  development          Use LNMP in Development(Support x86_64 arm32v7 arm64v8)
  development-config   Validate and view the Development(with build images)Compose file
  development-build    Use LNMP in Development With Build images(Support x86_64)
  down                 Stop and remove LNMP Docker containers, networks, images, and volumes
  docs                 Support Documents
  help                 Display this help message
  laravel              Create a new Laravel application
  laravel-artisan      Use Laravel CLI artisan
  mysql-demo           Create MySQL test database
  php                  Run PHP in CLI
  production           Use LNMP in Production(Only Support Linux x86_64)
  production-config    Validate and view the Production Compose file
  push                 Build and Pushes images to Docker Registory v2
  restore              Restore MySQL databases
  swarm                Docker Swarm

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
  init
  commit
  test
  test-image
  test-image-down
  dockerfile-update    Update Dockerfile By Script

Read './docs/*.md' for more information about commands."
    ;;
  esac
}

main $1 $2 $3 $4 $5 $6 $7 $8 $9
