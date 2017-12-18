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

NOTSUPPORT(){
  print_error "Not Support ${OS} ${ARCH}\n"; exit 1
}

env_status(){
  # .env.example to .env
  if [ -f .env ];then print_info ".env existing\n"; else print_error ".env NOT existing\n"; cp .env.example .env ; fi
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

error(){
  if [ $? -ne 0 ];then
    print_error "Error occurred, Please open issue in https://github.com/khs1994-docker/lnmp/issues/new\n"
    print_info "Maybe You can try exec\n\n$ ./lnmp-docker.sh update\n\n$ cp .env.example .env\n\n$ mv .env .env.backup\n"
    exit 1
  fi
}

lnmp_path(){
if [ -f bin/.env -a "$1" != "no" ];then
  . bin/.env
  if [ "$KHS1994_LNMP_DOCKER_MD5" = "ABC3CDE3FC4348E6EC90E487DE599E34" ];then
    print_info "LNMP_PATH in THIS PATH $PWD\n"
    echo > /dev/null 2>&1
  else
    lnmp_path no
  fi
elif [ ! -z ${LNMP_PATH} ];then
  print_info "LNMP_PATH is ${LNMP_PATH}\n"
  cd ${LNMP_PATH}
elif [ -d $HOME/lnmp ];then
  print_info "LNMP_PATH is $HOME/lnmp\n"
  cd $HOME/lnmp
elif [ -d /data/lnmp -a -f /data/lnmp/bin/.env ];then
  print_info "LNMP_PATH is /data/lnmp\n"
  cd /data/lnmp
else
  print_error "please exec this lnmp-docker in LNMP_PATH"
fi
}

lnmp_path

env_status ; ARCH=`uname -m` ; OS=`uname -s`

COMPOSE_LINK_OFFICIAL=https://github.com/docker/compose/releases/download
COMPOSE_LINK=https://code.aliyun.com/khs1994-docker/compose-cn-mirror/raw
# COMPOSE_LINK=https://git.cloud.tencent.com/khs1994-docker/compose-cn-mirror/raw

# 获取正确版本号

. .env ; . bin/.env

if [ -d .git ];then BRANCH=`git rev-parse --abbrev-ref HEAD`; fi

if [ ${OS} = "Darwin" ];then
  sed -i "" "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" .env
else
  sed -i "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" .env
fi

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
}

dockerfile_update_sed(){
  sed -i '' 's/^FROM.*/'"${2}"'/g' dockerfile/$1/Dockerfile
  sed -i '' 's/^TAG.*/TAG='"${3}"'/g' dockerfile/$1/.env
  git diff
}

dockerfile_update(){
  read -p "Soft is: " SOFT
  read -p "Version is: " VERSION
  case $SOFT in
    memcached )
      dockerfile_update_sed $SOFT "FROM $SOFT:$VERSION-alpine" $VERSION
      sed -i '' 's/^KHS1994_LNMP_MEMCACHED_VERSION.*/KHS1994_LNMP_MEMCACHED_VERSION='"${VERSION}"'/g' .env.example .env
    ;;
    nginx )
      dockerfile_update_sed $SOFT "FROM $SOFT:$VERSION-alpine" $VERSION
      sed -i '' 's/^KHS1994_LNMP_NGINX_VERSION.*/KHS1994_LNMP_NGINX_VERSION='"${VERSION}"'/g' .env.example .env
    ;;
    php-fpm )
      dockerfile_update_sed $SOFT "FROM php:$VERSION-fpm-alpine3.7" $VERSION
      sed -i '' 's/^KHS1994_LNMP_PHP_VERSION.*/KHS1994_LNMP_PHP_VERSION='"${VERSION}"'/g' .env.example .env
    ;;
    postgresql )
      dockerfile_update_sed $SOFT "FROM postgres:$VERSION-alpine" $VERSIO
      sed -i '' 's/^KHS1994_LNMP_POSTGRESQL_VERSION.*/KHS1994_LNMP_POSTGRESQL_VERSION='"${VERSION}"'/g' .env.example .env
    ;;
    rabbitmq )
      dockerfile_update_sed $SOFT "FROM $SOFT:$VERSION-management-alpine" $VERSION
      sed -i '' 's/^KHS1994_LNMP_RABBITMQ_VERSION.*/KHS1994_LNMP_RABBITMQ_VERSION='"${VERSION}"'/g' .env.example .env
    ;;
    redis )
      dockerfile_update_sed $SOFT "FROM $SOFT:$VERSION-alpine" $VERSION
      sed -i '' 's/^KHS1994_LNMP_REDIS_VERSION.*/KHS1994_LNMP_REDIS_VERSION='"${VERSION}"'/g' .env.example .env
    ;;
    * )
      print_error "Soft is not existing"
      exit 1
    ;;
  esac
}

# 是否安装 Docker Compose

install_docker_compose_official(){
  command -v docker-compose >/dev/null 2>&1
  if [ $? != 0 ];then print_error "docker-compose already install"; exit 1; fi
  if [ $ARCH != "x86_64" ];then NOTSUPPORT; fi
  # 版本在 bin/.env 文件定义
  # https://api.github.com/repos/docker/compose/releases/latest
  curl -L ${COMPOSE_LINK_OFFICIAL}/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
  chmod +x docker-compose
  print_info "Please exec\n\n$ sudo mv docker-compose /usr/local/bin\n"
  # in CoreOS you must move to /opt/bin
  exit 0
}

install_docker_compose(){
  local i=0
  command -v docker-compose >/dev/null 2>&1
  if [ $? = 0 ];then
    # 存在
    DOCKER_COMPOSE_VERSION_CONTENT=`docker-compose --version`
    # 但是要判断版本是不是最新的
    if [ ${OS} = Linux ];then
      if [ "$DOCKER_COMPOSE_VERSION_CONTENT" != "$DOCKER_COMPOSE_VERSION_CORRECT_CONTENT" ];then
        print_error "`docker-compose --version` NOT installed Correct version, reinstall..."
        if [ ${ARCH} = "armv7l" -o ${ARCH} = "aarch64" ];then sudo pip3 uninstall docker-compose; else sudo rm -rf `which docker-compose`; fi
        install_docker_compose
        i=$(($i+1))
        if [ "$i" -eq 2 ];then exit 1; fi
      else
        print_info "`docker-compose --version` already installed Correct version"
      fi
    elif [ ${OS} = Darwin ];then
      if [ "$DOCKER_COMPOSE_VERSION_CONTENT" != "$DOCKER_COMPOSE_VERSION_CORRECT_CONTENT" ];then
        print_error "`docker-compose --version` NOT installed Correct version, Please update you Docker for Mac to latest Edge version"
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

# 克隆示例项目、nginx 配置文件

demo() {
  if [ -d config/nginx/.git -o -f config/nginx/.git ];then
    echo > /dev/null 2>&1
  else
    print_info "Import app and nginx conf Demo ...\n"
    # 检查网络连接
    ping -c 3 -i 0.2 -W 3 baidu.com > /dev/null 2>&1 || ( print_error "Network connection error" ;exit 1)
    git submodule update --init --recursive
  fi
}

# 初始化

init() {
  # docker-compose 是否安装
  install_docker_compose
  case $APP_ENV in
    # 开发环境 拉取示例项目 [cn github]
    development )
      print_info "$APP_ENV\n"
      demo
      ;;

    # 生产环境 转移项目文件、配置文件、安装依赖包
    production )
      print_info "$APP_ENV\n"
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
  if [ "$1" != "-f" ];then
    GIT_STATUS=`git status -s --ignore-submodules`
    if [ ! -z "${GIT_STATUS}" ];then git status -s --ignore-submodules; echo; print_error "Please commit then update"; exit 1; fi
  fi
  git fetch lnmp
  print_info "\nBranch is ${BRANCH}\n"
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
  print_info "开始新的 RC 版本开发\n"
  print_info "Branch is ${BRANCH}\n"
  if [ ${BRANCH} = "dev" ];then
    git fetch origin
    git reset --hard origin/master
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
    if [ -z "$2" ];then read -p "请输入路径: ./app/" path; else path=$2; fi
    bin/laravel ${path}
    ;;

  laravel-artisan )
    run_docker
    if [ -z "$2" -o -z "$3" ];then
      read -p  "请输入路径: ./app/" path
      read -p  "请输入命令: php artisan " cmd
    else
      path="$2"
      cmd="$3"
    fi
    bin/php-artisan ${path} ${cmd}
    ;;

  composer )
    run_docker
    if [ -z "$2" -o -z "$3" ];then
      read -p "请输入路径: ./app/" path
      read -p  "请输入命令: composer " cmd
    else
      path="$2"
      cmd="$3"
    fi
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
    error
    ;;

    systemd )
      # 与 production 基本一致，docker-compose 不加 -d 参数
      run_docker
      # 仅允许运行在 Linux x86_64
      if [ `uname -s` = "Linux" -a ${ARCH} = "x86_64" ];then
        init
        docker-compose \
           -f docker-compose.yml \
           -f docker-compose.prod.yml \
           up
      else
        print_error "生产环境不支持 `uname -s` ${ARCH}\n"
      fi
      error
      ;;

  build )
    run_docker
    init
    if [ ${ARCH} = "x86_64" ];then docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d; else NOTSUPPORT; fi
    error
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
    error
    ;;

  production-config )
    init
    docker-compose \
          -f docker-compose.yml \
          -f docker-compose.prod.yml \
          config
    error
    ;;

  build-config )
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

  update )
    update $2
    ;;

  upgrade )
    update $2
    ;;

  mysql-cli )
    run_docker
    docker-compose exec mysql mysql -uroot -p${MYSQL_ROOT_PASSWORD}
    ;;

  php-cli )
    run_docker
    docker-compose exec php7 bash
    ;;

  phpmyadmin-cli )
    run_docker
    docker-compose exec phpmyadmin sh
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
    docker-compose -f docker-compose.build.yml build && docker-compose -f docker-compose.build.yml push
    error
    ;;

  php )
    run_docker
    PHP_CLI_DOCKER_TAG=${KHS1994_LNMP_PHP_VERSION}-alpine3.7
    if [ $ARCH = "x86_64" ];then
      PHP_CLI_DOCKER_IMAGE=php-fpm
    elif [ $ARCH = "armv7l" ];then
      PHP_CLI_DOCKER_IMAGE=arm32v7-php-fpm
      PHP_CLI_DOCKER_TAG=${KHS1994_LNMP_PHP_VERSION}-jessie
    elif [ $ARCH = "aarch64" ];then
      PHP_CLI_DOCKER_IMAGE=arm64v8-php-fpm
    else
      NOTSUPPORT
    fi
    if [ -z "$2" -o -z "$3" ];then
      read -p "请输入路径: ./app/" path
      read -p "请输入命令: $ php " cmd
    else
      path=$2
      cmd=$3
    fi
      docker run -it --rm \
        -v $PWD/app/${path}:/app \
        khs1994/${PHP_CLI_DOCKER_IMAGE}:${PHP_CLI_DOCKER_TAG} \
        php ${cmd}
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
    dockerfile_update
    ;;

  swarm-build )
    docker-compose -f docker-stack.yml build nginx php7
    ;;

  swarm-push )
    docker-compose -f docker-stack.yml push nginx php7
    ;;

  swarm )
    run_docker
    docker stack deploy -c docker-stack.yml lnmp
    if [ $? -eq 0 ];then
      docker stack ps lnmp
    else
      exit 1
    fi
    ;;

  swarm-down )
    docker stack rm lnmp
    ;;

  swarm-create )

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

  error )
    error
    ;;

  * )
  echo  -e "
Docker-LNMP CLI ${KHS1994_LNMP_DOCKER_VERSION}

Official WebSite https://lnmp.khs1994.com

Usage: ./docker-lnmp.sh COMMAND

Commands:
  backup               Backup MySQL databases
  build                Use LNMP With Self Build images(Support x86_64)
  build-config         Validate and view the Self Build images Compose file
  cleanup              Cleanup log files
  composer             Use PHP Package Management composer
  development          Use LNMP in Development
  down                 Stop and remove LNMP Docker containers, networks
  docs                 Support Documents
  help                 Display this help message
  laravel              Create a new Laravel application
  laravel-artisan      Use Laravel CLI artisan
  php                  Run PHP in CLI
  production           Use LNMP in Production(Only Support Linux x86_64)
  production-config    Validate and view the Production Compose file
  push                 Build and Pushes images to Your Docker Registory
  restore              Restore MySQL databases
  swarm-build          Build Swarm image (nginx php7)
  swarm-push           Push Swarm image (nginx php7)
  swarm-deploy         Deploy LNMP stack TO Swarm mode
  swarm-down           Remove LNMP stack IN Swarm mode
  systemd              Manage Docker LNMP by systemd(Only Support Linux x86_64)

Container CLI:
  memcached-cli
  mongo-cli
  mysql-cli
  nginx-cli
  php-cli
  phpmyadmin-cli
  postgres-cli
  rabbitmq-cli
  redis-cli

Tools:
  update               Upgrades LNMP
  upgrade              Upgrades LNMP
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
    sed -i "s/^ARM_ARCH.*/ARM_ARCH=arm32v7/g" .env
    sed -i "s/^ARM_PHP_BASED_OS.*/ARM_PHP_BASED_OS=stretch/g" .env
    sed -i "s/^ARM_BASED_OS.*/ARM_BASED_OS=/g" .env
elif [ ${ARCH} = "aarch64" ];then
    sed -i "s/^ARM_ARCH.*/ARM_ARCH=arm64v8/g" .env
    sed -i "s/^ARM_PHP_BASED_OS.*/ARM_PHP_BASED_OS=alpine3.7/g" .env
fi

main $1 $2 $3 $4 $5 $6 $7 $8 $9
