#!/bin/bash

# git remote add origin git@github.com:khs1994-docker/lnmp.git
# git remote add aliyun git@code.aliyun.com:khs1994-docker/lnmp.git
# git remote add tgit git@git.qcloud.com:khs1994-docker/lnmp.git
# git remote add coding git@git.coding.net:khs1994/lnmp.git

print_info(){
  echo -e "\033[32mINFO \033[0m  $@"
}

print_error(){
  echo -e "\033[31mERROR\033[0m  $@"
}

NOTSUPPORT(){
  print_error "Not Support ${OS} ${ARCH}\n"; exit 1
}

if [ -f cli/khs1994-robot.enc ];then
    print_info "Use LNMP CLI in LNMP Root $PWD\n"
else
    if ! [ -z "${LNMP_ROOT_PATH}" ];then
      # 存在环境变量，进入
      print_info "Use LNMP CLI in other Folder\n"
      cd ${LNMP_ROOT_PATH}
    else
      print_error  "在任意目录使用 LNMP CLI 必须设置环境变量，cli/README.md"
    fi
fi

if [ "$1" = "development" -o "$1" = "production" ];then APP_ENV=$1; fi

help(){
  echo  -e "
Docker-LNMP CLI ${KHS1994_LNMP_DOCKER_VERSION}

Official WebSite https://lnmp.khs1994.com

Usage: ./docker-lnmp.sh COMMAND

Commands:
  backup               Backup MySQL databases
  build                Use LNMP With Self Build images (Only Support x86_64)
  build-config         Validate and view the Self Build images Compose file
  cleanup              Cleanup log files
  compose              Install docker-compose
  config               Validate and view the Development Compose file
  development          Use LNMP in Development
  development-pull     Pull LNMP Docker Images in development
  daemon-socket        Expose Docker daemon on tcp://0.0.0.0:2375 without TLS on macOS
  down                 Stop and remove LNMP Docker containers, networks
  docs                 Read support documents
  help                 Display this help message
  init                 Init LNMP environment
  k8s                  Deploy LNMP on k8s
  k8s-down             Remove k8s LNMP
  production           Use LNMP in Production (Only Support Linux x86_64)
  production-config    Validate and view the Production Compose file
  production-pull      Pull LNMP Docker Images in production
  push                 Build and Pushes images to Docker Registory
  restore              Restore MySQL databases
  restart              Restart LNMP services
  swarm-build          Build Swarm image (nginx php7)
  swarm-push           Push Swarm image (nginx php7)
  swarm-deploy         Deploy LNMP stack TO Swarm mode
  swarm-down           Remove LNMP stack IN Swarm mode
  update               Upgrades LNMP
  upgrade              Upgrades LNMP

PHP Tools:
  apache-config        Generate Apache2 vhost conf
  composer             Use PHP Dependency Manager Composer
  laravel              Create a new Laravel application
  laravel-artisan      Use Laravel CLI artisan
  new                  New PHP Project and generate nginx conf and issue SSL certificate
  nginx-config         Generate nginx vhost conf
  php                  Run PHP in CLI
  phpunit              Run PHPUnit
  ssl                  Issue SSL certificate powered by acme.sh, Thanks Let's Encrypt
  ssl-self             Issue Self-signed SSL certificate
  tp                   Create a new ThinkPHP application

Container CLI:
  apache-cli
  mariadb-cli
  memcached-cli
  mongo-cli
  mysql-cli
  nginx-cli
  php-cli
  phpmyadmin-cli
  postgres-cli
  rabbitmq-cli
  redis-cli

Developer Tools:
  commit               Commit LNMP to Git
  cn-mirror            Push master branch to CN mirror
  dockerfile-update    Update Dockerfile By Script
  rc                   Start new release
  test                 Test LNMP

Read './docs/*.md' for more information about commands.

You can open issue in [ https://github.com/khs1994-docker/lnmp/issues ] when you meet problems.

Donate https://zan.khs1994.com
"
}

# env

env_status(){
  # cp .env.example to .env
  if [ -f .env ];then print_info ".env file existing\n"; else print_error ".env file NOT existing\n"; cp .env.example .env ; fi
}

update_version(){
  . .env.example

  local softs='PHP \
              NGINX \
              APACHE \
              MYSQL \
              MARIADB \
              REDIS \
              MEMCACHED \
              RABBITMQ \
              POSTGRESQL \
              MONGODB \
              '
  for soft in $softs; do
    version="KHS1994_LNMP_${soft}_VERSION"
    eval version=$(echo \$$version)
    if [ $OS = "Darwin" ];then
      sed -i '' 's/^KHS1994_LNMP_'"${soft}"'_VERSION.*/KHS1994_LNMP_'"${soft}"'_VERSION='"${version}"'/g' .env
    else
      sed -i 's/^KHS1994_LNMP_'"${soft}"'_VERSION.*/KHS1994_LNMP_'"${soft}"'_VERSION='"${version}"'/g' .env
    fi
  done
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

env_status ; ARCH=`uname -m` ; OS=`uname -s`

COMPOSE_LINK_OFFICIAL=https://github.com/docker/compose/releases/download
COMPOSE_LINK=https://code.aliyun.com/khs1994-docker/compose-cn-mirror/raw

# 获取正确版本号

. .env ; . cli/.env

if [ -d .git ];then BRANCH=`git rev-parse --abbrev-ref HEAD`; fi

if [ ${OS} = "Darwin" ];then
  sed -i "" "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" .env
else
  sed -i "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" .env
fi

# 创建日志文件

logs(){
  if ! [ -d logs/apache2 ];then mkdir -p logs/apache2; fi

  if ! [ -d logs/mongodb ];then mkdir -p logs/mongodb && echo > logs/mongodb/mongo.log; fi

  if ! [ -d logs/mysql ];then mkdir -p logs/mysql && echo > logs/mysql/error.log; fi

  if ! [ -d logs/mariadb ];then mkdir -p logs/mariadb && echo > logs/mariadb/error.log; fi

  if ! [ -d logs/nginx ];then mkdir -p logs/nginx && echo > logs/nginx/error.log && echo > logs/nginx/access.log; fi

  if ! [ -d logs/php-fpm ];then
    mkdir -p logs/php-fpm && echo > logs/php-fpm/error.log \
      && echo > logs/php-fpm/access.log \
      && echo > logs/php-fpm/xdebug-remote.log
  fi

  if ! [ -d logs/php-fpm/php ];then mkdir -p logs/php-fpm/php; fi

  if ! [ -d logs/redis ];then mkdir -p logs/redis && echo > logs/redis/redis.log ; fi
  chmod -R 777 logs/mongodb \
               logs/mysql \
               logs/nginx \
               logs/php-fpm \
               logs/redis

  # 不清理 Composer 缓存
  if ! [ -d tmp/cache ];then mkdir -p tmp/cache && chmod 777 tmp/cache; fi
}

# 清理日志文件

cleanup(){
      logs \
      && echo > logs/mongodb/mongo.log \
      && echo > logs/mysql/error.log \
      && echo > logs/mariadb/error.log \
      && echo > logs/nginx/error.log \
      && echo > logs/nginx/access.log \
      && echo > logs/php-fpm/access.log \
      && echo > logs/php-fpm/error.log \
      && echo > logs/php-fpm/xdebug-remote.log \
      && echo > logs/redis/redis.log \
      && echo > logs/apache2/access.log \
      && echo > logs/apache2/error.log \
      && echo > logs/php-fpm/php/error.log
      print_info "Clean log files SUCCESS\n"
}

gitbook(){
  docker rm -f lnmp-docs
  docker run -it --rm \
    -p 4000:4000 \
    --name lnmp-docs \
    -v $PWD/docs:/srv/gitbook-src \
    khs1994/gitbook \
    server
  exit 0
}

dockerfile_update_sed(){
  sed -i '' "s/^FROM.*/${2}/g" dockerfile/$1/Dockerfile
  sed -i '' "s/^TAG.*/TAG=${3}/g" dockerfile/$1/.env
  git diff
}

dockerfile_update(){
  read -p "Soft is: " SOFT
  if [ -z "$SOFT" ];then echo; print_error 'Please input content'; exit 1; fi
  read -p "Version is: " VERSION
  if [ -z "VERSION" ];then echo; print_error 'Please input content'; exit 1; fi
  case $SOFT in
    nginx )
      sed -i '' "s#^KHS1994_LNMP_NGINX_VERSION.*#KHS1994_LNMP_NGINX_VERSION=${VERSION}#g" .env.example .env
      sed -i '' "s#^    image: khs1994/nginx.*#    image: khs1994/nginx:swarm-$VERSION-alpine#g" docker-k8s.yml docker-stack.yml linuxkit/lnmp.yml
      ;;
    mysql )
      sed -i '' "s#^KHS1994_LNMP_MYSQL_VERSION.*#KHS1994_LNMP_MYSQL_VERSION=${VERSION}#g" .env.example .env
      sed -i '' "s#^    image: mysql.*#    image: mysql:$VERSION#g" docker-k8s.yml docker-stack.yml linuxkit/lnmp.yml
      ;;
    php-fpm )
      dockerfile_update_sed $SOFT "FROM php:$VERSION-fpm-alpine3.7" $VERSION
      sed -i '' "s#^KHS1994_LNMP_PHP_VERSION.*#KHS1994_LNMP_PHP_VERSION=${VERSION}#g" .env.example .env
      sed -i '' "s#^    image: khs1994/php-fpm.*#    image: khs1994/php-fpm:swarm-$VERSION-alpine3.7#g" docker-k8s.yml docker-stack.yml linuxkit/lnmp.yml
    ;;
    postgresql )
      dockerfile_update_sed $SOFT "FROM postgres:$VERSION-alpine" $VERSIO
      sed -i '' "s/^KHS1994_LNMP_POSTGRESQL_VERSION.*/KHS1994_LNMP_POSTGRESQL_VERSION=${VERSION}/g" .env.example .env
    ;;
    rabbitmq )
      dockerfile_update_sed $SOFT "FROM $SOFT:$VERSION-management-alpine" $VERSION
      sed -i '' "s/^KHS1994_LNMP_RABBITMQ_VERSION.*/KHS1994_LNMP_RABBITMQ_VERSION=${VERSION}/g" .env.example .env
    ;;
    redis )
      dockerfile_update_sed $SOFT "FROM $SOFT:$VERSION-alpine" $VERSION
      sed -i '' "s/^KHS1994_LNMP_REDIS_VERSION.*/KHS1994_LNMP_REDIS_VERSION=${VERSION}/g" .env.example .env
      sed -i '' "s#^    image: khs1994/redis.*#    image: khs1994/redis:$VERSION-alpine#g" docker-k8s.yml docker-stack.yml linuxkit/lnmp.yml
    ;;
    * )
      print_error "Soft is not existing"
      exit 1
    ;;
  esac
}

# 将 compose 移入 PATH

install_docker_compose_move(){
  if [ -f /etc/os-release ];then
    . /etc/os-release
    case "$ID" in
      coreos )
        if ! [ -d /opt/bin ];then sudo mkdir -p /opt/bin; fi
        sudo cp -a /tmp/docker-compose /opt/bin/docker-compose
        ;;
      * )
        sudo cp -a /tmp/docker-compose /usr/local/bin/docker-compose
        ;;
    esac
  else
    NOTSUPPORT
  fi
}

# 从 GitHub 安装 compose

install_docker_compose_official(){
  if [ "$OS" != 'Linux' ];then exit 1;fi
  curl -L ${COMPOSE_LINK_OFFICIAL}/$LNMP_DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
  chmod +x /tmp/docker-compose
  if [ "$1" = "-f" ];then
    install_docker_compose_move
  else
    print_info "Please exec\n\n$ sudo mv /tmp/docker-compose /usr/local/bin\n"
  fi
}

# 安装 compose arm 版本

install_docker_compose_arm(){
  print_info "$OS $ARCH docker-compose v$LNMP_DOCKER_COMPOSE_VERSION is installing by pip3 ...\n"
  command -v pip3 >/dev/null 2>&1
  if [ $? != 0 ];then sudo apt install -y python3-pip; fi
  if ! [ -d ~/.pip ];then
    mkdir -p ~/.pip; echo -e "[global]\nindex-url = https://pypi.douban.com/simple\n[list]\nformat=columns" > ~/.pip/pip.conf
  fi
  sudo pip3 install --upgrade docker-compose
}

install_docker_compose(){
  if ! [ "$OS" = 'Linux' ];then exit 1; fi
  if [ ${ARCH} = 'armv7l' ] || [ ${ARCH} = 'aarch64' ];then
    install_docker_compose_arm "$@"
  elif [ $ARCH = 'x86_64' ];then
    curl -L ${COMPOSE_LINK}/${LNMP_DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
    chmod +x /tmp/docker-compose
    if [ "$1" = '-f' ];then install_docker_compose_move; return 0;fi
    print_info "You MUST exec\n\n$ sudo mv /tmp/docker-compose /usr/local/bin/\n"
  fi
}

# 主函数

docker_compose(){
  command -v docker-compose >/dev/null 2>&1
  if [ $? = 0 ];then
    # 存在
    # 取得版本号
    DOCKER_COMPOSE_VERSION=`docker-compose --version | cut -d ' ' -f 3 | cut -d , -f 1`
    local x=`echo $DOCKER_COMPOSE_VERSION | cut -d . -f 1`
    local y=`echo $DOCKER_COMPOSE_VERSION | cut -d . -f 2`
    #local z=`echo $DOCKER_COMPOSE_VERSION | cut -d . -f 3`
    local true_x=`echo $LNMP_DOCKER_COMPOSE_VERSION | cut -d . -f 1`
    local true_y=`echo $LNMP_DOCKER_COMPOSE_VERSION | cut -d . -f 2`
    #local true_z=`echo $LNMP_DOCKER_COMPOSE_VERSION | cut -d . -f 3`
    if [ "$x" != "$true_x" ];then exit 1; fi
    # 判断是否安装正确
    # -lt 小于
    if [ "$y" -lt "$true_y" ];then
      # 安装不正确
      if [ "$1" = '--official' ];then shift; print_info "Install compose from GitHub"; install_docker_compose_official "$@"; return 0; fi
      if [ "$1" = '-f' ];then install_docker_compose -f; return 0; fi
      # 判断 OS
      if [ "$OS" = 'Darwin' ] ;then
        print_error "docker-compose v$DOCKER_COMPOSE_VERSION NOT installed Correct version, You MUST update Docker for Mac Edge Version\n"
      elif [ "$OS" = 'Linux' ];then
        print_error "docker-compose v$DOCKER_COMPOSE_VERSION NOT installed Correct version, You MUST EXEC $ ./lnmp-docker.sh compose -f\n"
      elif [ "$OS" = 'MINGW64_NT-10.0' ];then
        print_error "docker-compose v$DOCKER_COMPOSE_VERSION NOT installed Correct version, You MUST update Docker for Windows Edge Version\n"
      else
        NOTSUPPORT
      fi
    # 安装正确
    else
      print_info "docker-compose v$DOCKER_COMPOSE_VERSION already installed Correct version\n"; return 0
    fi
  else
    # 不存在
    print_error "docker-compose NOT install, install..."
    if [ "$1" = '--official' ];then shift; print_info "Install compose from GitHub"; exec install_docker_compose_official "$@"; fi
    install_docker_compose -f
  fi
}

# 克隆示例项目、nginx 配置文件

demo() {
  if [ -d config/nginx/.git ] || [ -f config/nginx/.git ];then
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
  # 升级软件版本
  update_version
  case $APP_ENV in
    # 开发环境 拉取示例项目 [cn github]
    development )
      print_info "$APP_ENV\n"
      demo
      ;;

    # 生产环境 转移项目文件、配置文件、安装依赖包
    production )
      print_info "$APP_ENV\n"
      # 请在 ./scripts/production-init 定义要执行的操作
      scripts/production-init
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

network(){
  if [ "$OS" = 'MINGW64_NT-10.0' ];then return 0; fi
  ping -c 3 -W 3 baidu.com > /dev/null 2>&1 || ( print_error "Network connection error" ;exit 1)
}

# 更新项目

set_git_remote_lnmp_url(){
  network
  GIT_SOURCE_URL=`git remote get-url lnmp`
  git remote get-url lnmp > /dev/null 2>&1
  if [ $? -ne 0 ];then
    # 不存在
    print_error "This git remote lnmp NOT set, seting..."
    git remote add lnmp git@github.com:khs1994-docker/lnmp.git
    # 不能使用 SSH
    git fetch lnmp > /dev/null 2>&1 || git remote set-url lnmp https://github.com/khs1994-docker/lnmp.git
    print_info `git remote get-url lnmp`
  elif [ ${GIT_SOURCE_URL} != 'git@github.com:khs1994-docker/lnmp.git' -a ${GIT_SOURCE_URL} != 'https://github.com/khs1994-docker/lnmp' ];then
    # 存在但是设置错误
    print_error "This git remote lnmp NOT set Correct, reseting..."
    git remote rm lnmp
    git remote add lnmp git@github.com:khs1994-docker/lnmp.git
    # 不能使用 SSH
    git fetch  lnmp > /dev/null 2>&1 || git remote set-url lnmp https://github.com/khs1994-docker/lnmp.git
    print_info `git remote get-url lnmp`
  fi
}

update(){
  # 不存在 .git 退出
  if ! [ -d .git ];then exit 1; fi

  set_git_remote_lnmp_url

  for force in "$@"
  do
    if [ "$force" = '-f' ];then force='true'; fi
  done

  GIT_STATUS=`git status -s --ignore-submodules`
  if [ ! -z "${GIT_STATUS}" ] && [ ! "$force" = 'true' ];then git status -s --ignore-submodules; echo; print_error "Please commit then update"; exit 1; fi
  git fetch lnmp
  print_info "Branch is ${BRANCH}\n"
  if [ ${BRANCH} = 'dev' ];then
    git submodule update --init --recursive
    git reset --hard lnmp/dev
  elif [ ${BRANCH} = 'master' ];then
    git submodule update --init --recursive
    git reset --hard lnmp/master
  else
    print_error "${BRANCH} error，Please checkout to dev or master branch\n\n$ git checkout dev\n "
  fi
  command -v bash > /dev/null 2>&1
  if ! [ $? = 0  ];then sed -i 's!^#\!/bin/bash.*!#\!/bin/sh!g' lnmp-docker.sh; fi
}

# 提交项目「开发者选项」

commit(){
  # 检查网络连接
  network && print_info `git remote get-url origin` ${BRANCH}
  if [ ${BRANCH} = 'dev' ];then
    git add .
    git commit -m "Update [skip ci]"
    git push origin dev
  else
    print_error "${BRANCH} error\n"
  fi
}

release_rc(){
  set_git_remote_lnmp_url
  print_info "Start new RC \n"; print_info "Branch is ${BRANCH}\n"
  if [ ${BRANCH} = 'dev' ];then
    git fetch lnmp
    git reset --hard lnmp/master
  else
    print_error "${BRANCH} error，Please checkout to  dev branch\n\n$ git checkout dev\n"
  fi
}

cn_mirror(){
  set_git_remote_lnmp_url
  git fetch lnmp
  git push -f aliyun remotes/lnmp/dev:dev
  git push -f aliyun remotes/lnmp/master:master
  git push -f aliyun --tags
  git push -f tgit remotes/lnmp/dev:dev
  git push -f tgit remotes/lnmp/master:master
  git push -f tgit --tags
  git push -f coding remotes/lnmp/dev:dev
  git push -f coding remotes/lnmp/master:master
  git push -f coding --tags
}

nginx_http(){

  echo "#
# Generate nginx config By khs1994-docker/lnmp
#
server {
  listen        80;
  server_name   $1;
  root          /app/$2;
  index         index.html index.htm index.php;

  location / {
    try_files \$uri \$uri/ /index.php?\$query_string;
  }

  location ~ .*\.php(\/.*)*$ {
    fastcgi_pass   php7:9000;
    include        fastcgi.conf;
  }
}" > config/nginx/$1.conf

}

apache_http(){
  echo "#
# Generate Apache2 connfig By khs1994-docker/lnmp
#
<VirtualHost *:80>
  DocumentRoot \"/app/$2\"
  ServerName $1
  ServerAlias $1

  ErrorLog \"logs/error.log\"
  CustomLog \"logs/access.log\" common

  <FilesMatch \.php$>
    SetHandler \"proxy:fcgi://php7:9000\"
  </FilesMatch>

  <Directory \"/app/$2\" >
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
  </Directory>

</VirtualHost>" >> config/apache2/httpd-vhosts.conf
}

apache_https(){
  echo "#
# Generate Apache2 HTTPS config By khs1994-docker/lnmp
#
<VirtualHost *:443>
  DocumentRoot \"/app/$2\"
  ServerName $1
  ServerAlias $1

  ErrorLog \"logs/error.log\"
  CustomLog \"logs/access.log\" common

  SSLEngine on
  SSLCertificateFile conf/ssl/$1.crt
  SSLCertificateKeyFile conf/ssl/$1.key

  # HSTS (mod_headers is required) (15768000 seconds = 6 months)
  Header always set Strict-Transport-Security \"max-age=15768000\"

  <FilesMatch \.php$>
    SetHandler \"proxy:fcgi://php7:9000\"
  </FilesMatch>

  <Directory \"/app/$2\" >
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
  </Directory>

</VirtualHost>" >> config/apache2/httpd-vhosts.conf
}

nginx_https(){

  echo "#
# Generate nginx HTTPS config By khs1994-docker/lnmp
#
server {
  listen                    80;
  server_name               $1;
  return 301                https://\$host\$request_uri;
}

server{
  listen                     443 ssl http2;
  server_name                $1;
  root                       /app/$2;
  index                      index.html index.htm index.php;

  ssl_certificate            conf.d/ssl/$1.crt;
  ssl_certificate_key        conf.d/ssl/$1.key;

  ssl_session_cache          shared:SSL:1m;
  ssl_session_timeout        5m;
  ssl_protocols              TLSv1.2;
  ssl_ciphers                'ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5';
  ssl_prefer_server_ciphers  on;

  ssl_stapling               on;
  ssl_stapling_verify        on;

  location / {
    try_files \$uri \$uri/ /index.php?\$query_string;
  }

  location ~ .*\.php(\/.*)*$ {
    fastcgi_pass   php7:9000;
    include        fastcgi.conf;
  }
}" > config/nginx/$1.conf

}

# 申请 ssl 证书

ssl(){
  if [ -z "$DP_Id" ];then print_error "Please set ENV in .env file"; exit 1; fi
  if [ -z "$1" ];then read -p "Please input domain: 「example www.domain.com 」" url; else url=$1; fi
  if [ -z "$url" ];then echo; print_error 'Please input content'; exit 1; fi
  if [ "$1" = 'acme.sh' ];then
  exec docker run -it --rm \
         -v $PWD/config/nginx/ssl:/ssl \
         --mount source=lnmp_ssl-data,target=/root/.acme.sh \
         --env-file .env \
         khs1994/acme "$@"

  # ./lnmp-docker.sh ssl acme.sh --issue --dns dns_gd -d example.com -d www.example.com

  fi
  exec docker run -it --rm \
         -v $PWD/config/nginx/ssl:/ssl \
         --mount source=lnmp_ssl-data,target=/root/.acme.sh \
         --env-file .env \
         -e DNS_TYPE=$DNS_TYPE \
         -e url=$url \
         khs1994/acme
}

ssl_self(){
  docker run -it --rm -v $PWD/config/nginx/ssl:/ssl khs1994/tls "$@"
}

# 快捷开始 PHP 项目开发

start(){
  for arg in "$@"
  do
    if [ $arg = '-f' ];then rm -rf app/$1; fi
  done

  if [ -z "$1" ];then read -p "Please input project name: /app/" name; else name=$1; fi

  if [ -z "$name" ];then echo; print_error 'Please input content'; exit 1; fi

  if [ -d app/$name ];then print_error "This folder existing"; exit 1; fi

  if [ -z "$2" -o "$2" = '-f' ];then read -p "Please input domain:「example http[s]://$name.domain.com 」" input_url; else input_url=$2; fi

  if [ -z "$input_url" ]; then echo; print_error 'Please input content'; exit 1; fi

  protocol=$(echo $input_url | awk -F':' '{print $1}')

  url=$(echo $input_url | awk -F'[/:]' '{print $4}')

  if [ -z $url ];then url=$input_url; protocol=http; fi

  echo; print_info "PROTOCOL IS $protocol\n"

  print_info "URL IS $url"

  if [ $protocol = 'https' ];then
    # 申请 ssl 证书
    read -n 1 -t 5 -p "如果要申请自签名证书请输入 y Self-Signed SSL certificate? [y/N]:" self_signed
    if [ "$self_signed" = 'y' ];then
      ssl_self $url
    else
      ssl $url
    fi
    # 生成 nginx 配置文件
    nginx_https $url $name
  else
    nginx_http $url $name
  fi

  mkdir -p app/$name

  print_info "Now you can start PHP project in /app/$name"
  print_info "Please set hosts in /etc/hosts in development"
}

php_cli(){
  local MAIN_COMMAND=$1
  shift
  PHP_CLI_DOCKER_TAG=${KHS1994_LNMP_PHP_VERSION}-alpine3.7
  if [ $ARCH = 'x86_64' ];then
    PHP_CLI_DOCKER_IMAGE=php-fpm
  elif [ $ARCH = 'armv7l' ];then
    PHP_CLI_DOCKER_IMAGE=arm32v7-php-fpm
    PHP_CLI_DOCKER_TAG=${KHS1994_LNMP_PHP_VERSION}-jessie
  elif [ $ARCH = 'aarch64' ];then
    PHP_CLI_DOCKER_IMAGE=arm64v8-php-fpm
  else
    NOTSUPPORT
  fi
  if [ $MAIN_COMMAND = 'php' ] && [ -z "$2" ];then
    print_error "$ ./lnmp-docker.sh $MAIN_COMMAND {PATH} {CMD}"
    exit 1
  else
    path=$1
    shift
    CMD="$@"
  fi

  if [ -z $path ];then print_error "$ ./lnmp-docker.sh $MAIN_COMMAND {PATH} [CMD]"; exit 1; fi

  print_info "在 khs1994/${PHP_CLI_DOCKER_IMAGE}:${PHP_CLI_DOCKER_TAG} 内 /app/${path} 执行 $ ${MAIN_COMMAND} ${CMD}\n" && print_info "以下为输出内容\n\n"
    exec docker run -it --rm \
      -v $PWD/app/${path}:/app \
      khs1994/${PHP_CLI_DOCKER_IMAGE}:${PHP_CLI_DOCKER_TAG} \
      $MAIN_COMMAND ${CMD}
}

# 入口文件

main() {
  logs; print_info "ARCH is ${OS} ${ARCH}\n"; print_info `docker --version`; echo; docker_compose
  local command=$1; shift
  case $command in
  init )
    init
    ;;

  backup )
    run_docker; backup "$@"
    ;;

  config )
    exec docker-compose config
    ;;

  demo )
    demo
    ;;

  cleanup )
    cleanup
    ;;

  test )
    run_docker; cli/test
    ;;

  commit )
    commit
    ;;
  rc )
    release_rc
    ;;

  laravel )
    run_docker; if [ -z "$1" ];then read -p "Please inuput PHP path: ./app/" path; else path="$1"; shift ; cmd="$@"; fi
    if [ -z "${path}" ];then echo; print_error 'Please input content'; exit 1; fi
    if [ -z "$cmd" ];then cli/laravel ${path}; else cli/laravel ${path} "${cmd}"; fi
    ;;

  laravel-artisan )
    run_docker
    if [ -z "$2" ];then
      print_error "$ ./lnmp-docker.sh laravel-artisan {PATH} {CMD}"; exit 1
    else
      path="$1"
      shift
      cmd="$@"
    fi
    cli/php-artisan ${path} "${cmd}"
    ;;

  composer )
    run_docker
    if [ -z "$2" ];then
      print_error "$ ./lnmp-docker.sh composer {PATH} {CMD}"; exit 1
    else
      path="$1"
      shift
      cmd="$@"
    fi
    cli/composer ${path} "${cmd}"
    ;;

  production )
    run_docker
    # 仅允许运行在 Linux x86_64
    if [ "$OS" = 'Linux' ] && [ ${ARCH} = 'x86_64' ];then
      init
      if ! [ "$1" = "--systemd" ];then opt='-d'; else opt= ; fi
      docker-compose -f docker-compose.yml -f docker-compose.prod.yml up $opt
      echo; sleep 2; print_info "Test nginx configuration file...\n"
      docker-compose -f docker-compose.yml -f docker-compose.prod.yml exec nginx nginx -t
      if [ $? = 0 ];then
        echo; print_info "nginx configuration file test is successful\n" ; exit 0
      else
        echo; print_error "nginx configuration file test failed, You must check nginx configuration file!"; exit 1
      fi
    else
      print_error "Production NOT Support ${OS} ${ARCH}\n"
    fi
    ;;

  production-config )
    init; exec docker-compose -f docker-compose.yml -f docker-compose.prod.yml config
    ;;

  production-pull )
    run_docker
    # 仅允许运行在 Linux x86_64
    if [ "$OS" = 'Linux' ] && [ ${ARCH} = 'x86_64' ];then
      init; sleep 2; exec docker-compose -f docker-compose.yml -f docker-compose.prod.yml pull
    else
      print_error "Production NOT Support ${OS} ${ARCH}\n"
    fi
    ;;

  build )
    run_docker; init; if [ ${ARCH} = 'x86_64' ];then exec docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d; else NOTSUPPORT; fi
    ;;

  development )
    run_docker
    init
    # 判断架构
    if [ "$1" != '--systemd' ];then opt='-d'; else opt= ;fi
    if [ ${ARCH} = 'x86_64' ];then
      docker-compose up $opt
      echo; sleep 1; print_info "Test nginx configuration file...\n"
      docker-compose exec nginx nginx -t
    elif [ ${ARCH} = 'armv7l' -o ${ARCH} = 'aarch64' ];then
      docker-compose -f docker-compose.arm.yml up $opt
      echo; sleep 1; print_info "Test nginx configuration file...\n"
      docker-compose -f docker-compose.arm.yml exec nginx nginx -t
    else
      NOTSUPPORT
    fi

    if [ $? = 0 ];then
      echo; print_info "nginx configuration file test is successful\n" ; exit 0
    else
      echo; print_error "nginx configuration file test failed, You must check nginx configuration file!"; exit 1
    fi
    ;;

  build-config )
    init; if [ ${ARCH} = 'x86_64' ];then exec docker-compose -f docker-compose.yml -f docker-compose.build.yml config; else NOTSUPPORT; fi
    ;;

  restore )
    run_docker; restore "$@"
    ;;

  update|upgrade )
    update "$@"
    ;;

  mysql-cli )
    run_docker; docker-compose exec mysql mysql -uroot -p${MYSQL_ROOT_PASSWORD}
    ;;

  nginx-conf )
     if [ -z "$3" ];then print_error "$ ./lnmp-docker.sh nginx-conf {https|http} {PATH} {URL}"; exit 1; fi
     print_info 'Please set hosts in /etc/hosts in development\n'
     print_info 'Maybe you need generate nginx HTTPS conf in website https://khs1994-website.github.io/server-side-tls/ssl-config-generator/'
     if [ "$1" = 'http' ];then shift; nginx_http $2 $1; fi
     if [ "$1" = 'https' ];then shift; nginx_https $2 $1; fi
     ;;

  apache-conf )
    if [ -z "$3" ];then print_error "$ ./lnmp-docker.sh apache-conf {https|http} {PATH} {URL}"; exit 1; fi
    print_info 'Please set hosts in /etc/hosts in development\n'
    print_info 'Maybe you need generate Apache2 HTTPS conf in website https://khs1994-website.github.io/server-side-tls/ssl-config-generator/'
    if [ "$1" = 'http' ];then shift; apache_http $2 $1; fi
    if [ "$1" = 'https' ];then shift; apache_https $2 $1; fi
    ;;

  apache-delete )

    ;;

  nginx-delete )
    mv config/nginx/$1.conf config/nginx/$1.conf.delete
    ;;

  php-cli )
    run_docker; docker-compose exec php7 bash
    ;;

  phpmyadmin-cli )
    run_docker; docker-compose exec phpmyadmin sh
    ;;

  redis-cli )
    run_docker; docker-compose exec redis sh
    ;;

  memcached-cli )
    run_docker; docker-compose exec memcached sh
    ;;

  rabbitmq-cli )
    run_docker; docker-compose exec rabbitmq sh
    ;;

  postgres-cli )
    run_docker; docker-compose exec postgresql sh
    ;;

  mongo-cli )
    run_docker; docker-compose exec mongodb bash
    ;;

  nginx-cli )
    run_docker; docker-compose exec nginx sh
    ;;

  apache-cli )
    run_docker; docker-compose exec apache sh
    ;;

  mariadb-cli )
    run_docker; docker-compose exec mariadb bash
    ;;

  push )
    run_docker; init; exec docker-compose -f docker-compose.build.yml build && docker-compose -f docker-compose.build.yml push
    ;;

  php )
    run_docker; php_cli php "$@"
    ;;

  phpunit )
    run_docker; php_cli vendor/bin/phpunit "$@"
    ;;

  down )
    init; docker-compose down --remove-orphans
    ;;

  docs )
    run_docker; gitbook
    ;;

  dockerfile-update )
    dockerfile_update
    ;;

  swarm-build )
    docker-compose -f docker-stack.yml build
    ;;

  swarm-push )
    docker-compose -f docker-stack.yml push nginx php7
    ;;

  swarm-deploy )
    run_docker; docker stack deploy -c docker-stack.yml lnmp; if [ $? -eq 0 ];then docker stack ps lnmp; else exit 1; fi
    ;;

  swarm-down )
    docker stack rm lnmp
    ;;

  development-pull )
    run_docker; init
    case "${ARCH}" in
        x86_64 )
          sleep 2; exec docker-compose pull
          ;;
        aarch64 | armv7l )
          sleep 2; exec docker-compose -f docker-compose.arm.yml pull
          ;;
        * )
          NOTSUPPORT
          ;;
    esac
     ;;

  cn-mirror )
    cn_mirror
    ;;

  compose )
    docker_compose "$@"
    ;;

  new )
    start "$@"
    ;;

  ssl )
    ssl "$@"
    ;;

  ssl-self )
    if [ -z "$1" ];then print_error '$ ./lnmp-docker.sh ssl-self {IP|DOMAIN}'; exit 1; fi
    ssl_self "$@"
    echo; print_info 'Please set hosts in /etc/hosts'
    ;;

  tests )
    print_info "Test Shell Script"
    exec echo
    ;;

  version )
    echo Docker-LNMP ${KHS1994_LNMP_DOCKER_VERSION}
    ;;

  -h | --help | help )
   help
   ;;

  k8s )
    cd kubernetes; ./kubernetes.sh deploy
    ;;

  k8s-down )
    cd kubernetes; ./kubernetes.sh cleanup
    ;;

  tp )
    run_docker
    if [ -z "$1" ];then
      print_error "$ ./lnmp-docker.sh tp {PATH} {CMD}"; exit 1
    else
      path="$1"
      shift
      cmd="$@"
    fi
    cli/composer "" "create-project topthink/think=5.0.* ${path} --prefer-dist ${cmd}"
    ;;

  restart )
    if [ -z "$1" ];then docker-compose down --remove-orphans; print_info "Please exec \n\n$ ./lnmp-docker.sh development | production\n"; exit 0; fi

    for soft in "$@"
    do
      if [ $soft = 'nginx' ];then opt='true'; fi
    done

    if [ "$opt" = 'true' ];then
      docker-compose exec nginx nginx -t
      if [ "$?" = 0 ];then
        echo; print_info "nginx configuration file test is successful\n"
        docker-compose $command "$@"
      else
        echo; print_error "nginx configuration file test failed, You must check nginx configuration file!"; exit 1;
      fi
    else
      print_info "You Exec docker-compose commands"; echo
      exec docker-compose $command "$@"
    fi
    ;;

 daemon-socket )
   if [ $OS != 'Darwin' ];then NOTSUPPORT; fi
   docker run -d --restart=always \
     -p 2375:2375 \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -e PORT=2375 \
     shipyard/docker-proxy
     ;;

  * )
  if ! [ -z "$command" ];then
    print_info "You Exec docker-compose commands"; echo
    exec docker-compose $command "$@"
  fi
  help
    ;;
  esac
}

# i=0

if [ ${ARCH} = 'armv7l' ];then
    sed -i "s/^ARM_ARCH.*/ARM_ARCH=arm32v7/g" .env
    sed -i "s/^ARM_PHP_BASED_OS.*/ARM_PHP_BASED_OS=stretch/g" .env
    sed -i "s/^ARM_BASED_OS.*/ARM_BASED_OS=/g" .env
elif [ ${ARCH} = 'aarch64' ];then
    sed -i "s/^ARM_ARCH.*/ARM_ARCH=arm64v8/g" .env
    sed -i "s/^ARM_PHP_BASED_OS.*/ARM_PHP_BASED_OS=alpine3.7/g" .env
fi

main "$@"
