#!/bin/bash

# git remote add origin git@github.com:khs1994-docker/lnmp.git
# git remote add aliyun git@code.aliyun.com:khs1994-docker/lnmp.git
# git remote add tgit git@git.qcloud.com:khs1994-docker/lnmp.git
# git remote add coding git@git.coding.net:khs1994/lnmp.git

if [ "$1" = "development" -o "$1" = "production" ];then APP_ENV=$1; fi

# env
print_info(){
  echo -e "\033[32mINFO \033[0m  $@"
}

print_error(){
  echo -e "\033[31mERROR\033[0m  $@"
}

env_status(){
  # .env.example to .env
  if [ -f .env ];then print_info ".env existing\n"; else print_error ".env NOT existing\n"; cp .env.example .env ; fi
  if [ -f dockerfile/.env ];then print_info "dockerfile/.env existing\n"; else print_error "dockerfile/.env NOT existing\n"; cp dockerfile/.env.example dockerfile/.env ; fi
}

run_docker(){
  docker info 2>&1 >/dev/null
  if [ $? -ne 0 ];then
    clear
    echo "=========================="
    echo "=== Please Run Docker ===="
    echo "=========================="
    exit 1
  fi
}

env_status
ARCH=`uname -m`
OS=`uname -s`
if [ -d .git ];then BRANCH=`git rev-parse --abbrev-ref HEAD`; fi
COMPOSE_LINK_OFFICIAL=https://github.com/docker/compose/releases/download
COMPOSE_LINK=https://code.aliyun.com/khs1994-docker/compose-cn-mirror/raw
# COMPOSE_LINK=https://git.cloud.tencent.com/khs1994-docker/compose-cn-mirror/raw

# 获取正确版本号

. .env
. env/.env

if [ ${OS} = "Darwin" ];then
  # 将以什么开头的行替换为新内容
  sed -i "" "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" .env
  sed -i "" "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" dockerfile/.env
else
  sed -i "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" .env
  sed -i "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" dockerfile/.env
fi

# 不支持信息

NOTSUPPORT(){
  print_error "Not Support ${OS} ${ARCH}\n"; exit 1
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
    -v $PWD/docs:/srv/gitbook-src \
    khs1994/gitbook \
    server

  exit 0
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
      dockerfile-update-sed $SOFT "FROM $SOFT:$VERSION-alpine" $VERSION
      sed -i '' 's/^KHS1994_LNMP_MEMCACHED_VERSION.*/KHS1994_LNMP_MEMCACHED_VERSION='"${VERSION}"'/g' .env.example dockerfile/.env dockerfile/.env.example .env
    ;;
    nginx )
      dockerfile-update-sed $SOFT "FROM $SOFT:$VERSION-alpine" $VERSION
      sed -i '' 's/^KHS1994_LNMP_NGINX_VERSION.*/KHS1994_LNMP_NGINX_VERSION='"${VERSION}"'/g' .env.example dockerfile/.env dockerfile/.env.example .env
    ;;
    php-fpm )
      dockerfile-update-sed $SOFT "FROM php:$VERSION-fpm-alpine3.6" $VERSION
      sed -i '' 's/^KHS1994_LNMP_PHP_VERSION.*/KHS1994_LNMP_PHP_VERSION='"${VERSION}"'/g' .env.example dockerfile/.env dockerfile/.env.example .env
    ;;
    postgresql )
      dockerfile-update-sed $SOFT "FROM postgres:$VERSION-alpine" $VERSIO
      sed -i '' 's/^KHS1994_LNMP_POSTGRESQL_VERSION.*/KHS1994_LNMP_POSTGRESQL_VERSION='"${VERSION}"'/g' .env.example dockerfile/.env dockerfile/.env.example .env
    ;;
    rabbitmq )
      dockerfile-update-sed $SOFT "FROM $SOFT:$VERSION-management-alpine" $VERSION
      sed -i '' 's/^KHS1994_LNMP_RABBITMQ_VERSION.*/KHS1994_LNMP_RABBITMQ_VERSION='"${VERSION}"'/g' .env.example dockerfile/.env dockerfile/.env.example .env
    ;;
    redis )
      dockerfile-update-sed $SOFT "FROM $SOFT:$VERSION-alpine" $VERSION
      sed -i '' 's/^KHS1994_LNMP_REDIS_VERSION.*/KHS1994_LNMP_REDIS_VERSION='"${VERSION}"'/g' .env.example dockerfile/.env dockerfile/.env.example .env
    ;;
    * )
      print_error "Soft is not existing"
      exit 1
    ;;
  esac
}

# 是否安装 Docker Compose

install_docker_compose_official(){
  # 版本在 env/.env 文件定义
  # https://api.github.com/repos/docker/compose/releases/latest
  curl -L ${COMPOSE_LINK_OFFICIAL}/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
  chmod +x docker-compose
  print_info $PATH && sudo mv docker-compose /usr/local/bin
  # in CoreOS you must move to /opt/bin
}

install_docker_compose(){
  local i=0
  command -v docker-compose >/dev/null 2>&1
  if [ $? = 0 ];then
    # 存在
    if [ ${OS} = Linux ];then
      DOCKER_COMPOSE_VERSION_CONTENT=`docker-compose --version`
      if [ "$DOCKER_COMPOSE_VERSION_CONTENT" != "$DOCKER_COMPOSE_VERSION_CORRECT_CONTENT" ];then
        print_error "`docker-compose --version` NOT installed Correct version, reinstall..."
        if [ ${ARCH} = "armv7l" -o ${ARCH} = "aarch64" ];then sudo pip3 uninstall docker-compose; else sudo rm -rf `which docker-compose`; fi
        install_docker_compose
        i=$(($i+1))
        if [ "$i" -eq 2 ];then exit 1; fi
      else
        print_info "`docker-compose --version` already installed Correct version"
      fi
    fi
  else
    # 不存在
    print_error "docker-compose NOT installed, v${DOCKER_COMPOSE_VERSION} is installing ...\n"
    if [ ${ARCH} = "armv7l" -o ${ARCH} = "aarch64" ];then
      #arm
      print_info "${ARCH} docker-compose v${DOCKER_COMPOSE_VERSION} is installing by pip3 ...\n"
      command -v pip3 >/dev/null 2>&1
      if [ ! $? = 0 ];then sudo apt install -y python3-pip; fi
      # pip 源
      if [ ! -d ~/.pip ];then mkdir -p ~/.pip; echo -e "[global]\nindex-url = https://pypi.douban.com/simple\n[list]\nformat=columns" > ~/.pip/pip.conf; fi
      sudo pip3 install --upgrade docker-compose
    elif [ $OS = "Linux" -o $OS = "Darwin" ];then
      curl -L ${COMPOSE_LINK}/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o docker-compose
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

mysql_demo() {
  docker-compose exec mysql /backup/demo.sh
}

# 克隆示例项目、nginx 配置文件

demo() {
  #statements
  print_info "Import app and nginx conf Demo ...\n"
  git submodule update --init --recursive
}

# 初始化

init() {
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
  # 不存在 .git 退出
  if [ ! -d .git ];then exit 1; fi
  # 检查网络连接
  ping -c 3 -i 0.2 -W 3 baidu.com > /dev/null 2>&1 || ( print_error "Network connection error" ;exit 1)
  # 检查源链接
  git remote get-url lnmp > /dev/null 2>&1 && GIT_SOURCE_URL=`git remote get-url lnmp`
  if [ $? -ne 0 ];then
    # 不存在
    print_error "Your git remote lnmp NOT set, seting..."
    git remote add lnmp git@github.com:khs1994-docker/lnmp.git
    # 不能使用 SSH
    git fetch lnmp > /dev/null 2>&1 || git remote set-url lnmp https://github.com/khs1994-docker/lnmp.git
    print_info `git remote get-url lnmp`
  elif [ ${GIT_SOURCE_URL} != "git@github.com:khs1994-docker/lnmp.git" -a ${GIT_SOURCE_URL} != "https://github.com/khs1994-docker/lnmp" ];then
    # 存在但是设置错误
    print_error "Your git remote lnmp NOT set Correct, reseting..."
    git remote rm lnmp
    git remote add lnmp git@github.com:khs1994-docker/lnmp.git
    # 不能使用 SSH
    git fetch  lnmp > /dev/null 2>&1 || git remote set-url lnmp https://github.com/khs1994-docker/lnmp.git
    print_info `git remote get-url lnmp`
  fi
  GIT_STATUS=`git status -s --ignore-submodules`
  if [ ! -z "${GIT_STATUS}" ];then git status -s --ignore-submodules; echo; print_error "Please commit then update"; exit 1; fi
  git fetch lnmp
  print_info "Branch is ${BRANCH}\n"
  if [ ${BRANCH} = "dev" ];then
    git reset --hard lnmp/dev
  elif [ ${BRANCH} = "master" ];then
    git reset --hard lnmp/master
  else
    print_error "不能在 ${BRANCH} 自动更新，请切换到 dev 或 master 分支"
    echo -e "\nPlease exec\n\n$ git checkout dev\n"
  fi
}

# 提交项目「开发者选项」

commit(){
  print_info `git remote get-url origin` ${BRANCH}
  if [ ${BRANCH} = "dev" ];then
    git add .
    git commit -m "Update [skip ci]"
    git push origin dev
    mirror
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
    # git push -f origin dev
  else
    print_error "不能在 ${BRANCH} 分支开始新的开发，请切换到 dev 分支\n"
    echo -e "\n $ git checkout dev\n"
  fi
}

mirror(){
  git fetch origin
  git push -f aliyun dev:dev
  git push -f aliyun master:master
  git push -f aliyun --tags
  git push -f tgit dev:dev
  git push -f tgit master:master
  git push -f tgit --tags
  git push -f coding dev:dev
  git push -f coding master:master
  git push -f coding --tags
}

# 入口文件

main() {
  # 创建日志文件夹
  logs
  # no sudo
  # if [[ $EUID -eq 0 ]]; then print_error "This script should not be run using sudo!!\n"; exit 1; fi
  # 架构
  print_info "ARCH is ${OS} ${ARCH}\n"
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
    run_docker
    bin/test
    ;;

  commit )
    commit
    ;;
  rc )
    release_rc
    ;;

  laravel )
    run_docker
    read -p "请输入路径: ./app/" path
    bin/laravel ${path}
    ;;

  laravel-artisan )
    run_docker
    read -p  "请输入路径: ./app/" path
    read -p  "请输入命令: php artisan " cmd
    bin/php-artisan ${path} ${cmd}
    ;;

  composer )
    run_docker
    read -p "请输入路径: ./app/" path
    read -p  "请输入命令: composer " cmd
    bin/composer ${path} ${cmd}
    ;;

  production )
    run_docker
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

  development-build )
    run_docker
    init
    if [ ${ARCH} = "x86_64" ];then docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d; else NOTSUPPORT; fi
    ;;

  development )
    run_docker
    init
    # 判断架构
    if [ ${ARCH} = "x86_64" ];then
      docker-compose up -d
    elif [ ${ARCH} = "armv7l" -o ${ARCH} = "aarch64" ];then
        docker-compose -f docker-compose.arm.yml up -d
    else
      NOTSUPPORT
    fi
    ;;

  production-config )
    init
    docker-compose \
          -f docker-compose.yml \
          -f docker-compose.prod.yml \
          config
    ;;

  development-config )
    init
    # 判断架构
    if [ ${ARCH} = "x86_64" ];then
      docker-compose \
        -f docker-compose.yml \
        -f docker-compose.build.yml \
        config
    elif [ ${ARCH} = "armv7l" -o ${ARCH} = "aarch64" ];then
      docker-compose \
        -f docker-compose.arm.yml \
        config
    else
      NOTSUPPORT
    fi
    ;;

  backup )
    run_docker
    backup $2 $3 $4 $5 $6 $7 $8 $9
    ;;

  restore )
    run_docker
    restore $2
    ;;

  mysql-demo )
    run_docker
    mysql_demo
    ;;

  update )
    update
    ;;

  upgrade )
    update
    ;;

  mysql-cli )
    run_docker
    docker-compose exec mysql mysql -uroot -p${MYSQL_ROOT_PASSWORD}
    ;;

  php-cli )
    run_docker
    docker-compose exec php7 bash
    ;;

  redis-cli )
    run_docker
    docker-compose exec redis sh
    ;;
  memcached-cli )
    run_docker
    docker-compose exec memcached sh
    ;;
  rabbitmq-cli )
    run_docker
    docker-compose exec rabbitmq sh
    ;;
  postgres-cli )
    run_docker
    docker-compose exec postgresql sh
    ;;
  mongo-cli )
    run_docker
    docker-compose exec mongodb bash
    ;;
  nginx-cli )
    run_docker
    docker-compose exec nginx sh
    ;;

  push )
    run_docker
    init
    cd dockerfile
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
    run_docker
    if [ $ARCH = "x86_64" ];then
      PHP_CLI_DOCKER_IMAGE=php-fpm
      PHP_CLI_DOCKER_TAG=${KHS1994_LNMP_PHP_VERSION}-alpine3.6
    elif [ $ARCH = "armv7l" ];then
      PHP_CLI_DOCKER_IMAGE=arm32v7-php-fpm
      PHP_CLI_DOCKER_TAG=${KHS1994_LNMP_PHP_VERSION}-jessie
    elif [ $ARCH = "aarch64" ];then
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
    run_docker
    gitbook
    ;;

  dockerfile-update )
    dockerfile-update
    ;;

  swarm )
    run_docker
    docker stack deploy \
      -c docker-stack.yml \
      lnmp
    if [ $? -eq 0 ];then
      docker stack ps lnmp
    else
      exit 1
    fi
    ;;

  swarm-down )
    docker stack rm lnmp
    ;;

  debug )
    run_docker
    install_docker_compose
    ;;

  cn-mirror )
    mirror
    ;;

  compose )
    install_docker_compose_official
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
  swarm                Swarm mode
  swarm-down           Down Swarm mode

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
  upgrade               Upgrades LNMP
  init
  commit
  test
  dockerfile-update    Update Dockerfile By Script
  debug                Debug environment
  cn-mirror            Push master branch to CN mirror
  compose              Install docker-compose By curl from github

Read './docs/*.md' for more information about commands."
    ;;
  esac
}

# i=0

if [ ${ARCH} = "armv7l" ];then
    sed -i "s/^ARM_ARCH.*/ARM_ARCH=arm32v7/g" .env .env.example
    sed -i "s/^ARM_BASED_OS.*/ARM_BASED_OS=stretch/g" .env .env.example
    sed -i "s/^ARM_ALPINE_OS.*/ARM_ALPINE_OS=/g" .env .env.example
elif [ ${ARCH} = "aarch64" ];then
    sed -i "s/^ARM_ARCH.*/ARM_ARCH=arm64v8/g" .env .env.example
    sed -i "s/^ARM_BASED_OS.*/ARM_BASED_OS=alpine3.6/g" .env .env.example
fi

main $1 $2 $3 $4 $5 $6 $7 $8 $9

if [ $? -ne 0 ];then
  print_error "\nError occurred, try Rebuild environment! please open issue in https://github.com/khs1994-docker/lnmp/issues/new"
  echo
  # 重新生成 .env
  mv .env .env.backup
  rm -rf .env
  cp .env.example .env
  # 更新项目
  # main update
  print_info "Please exec"
  echo -e "\n$ ./lnmp-docker.sh update \n"
  exit 1
fi
