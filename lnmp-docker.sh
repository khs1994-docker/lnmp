#!/bin/bash

# git remote add origin git@github.com:khs1994-docker/lnmp.git
# git remote add aliyun git@code.aliyun.com:khs1994-docker/lnmp.git
# git remote add tgit git@git.qcloud.com:khs1994-docker/lnmp.git
# git remote add coding git@git.coding.net:khs1994/lnmp.git

# Don't Run this shell script on git bash Windows, please use ./lnmp-docker.ps1

if [ `uname -s` != 'Darwin' ] && [ `uname -s` != 'Linux' ];then echo -e "\n\033[31mError \033[0m  Please use ./lnmp-docker.ps1 on PowerShell in Windows"; exit 1; fi

# 系统环境变量具有最高优先级

env > /tmp/.khs1994.env

print_info(){
  echo -e "\033[32mINFO \033[0m  $@"
}

print_error(){
  echo -e "\033[31mERROR\033[0m  $@"
}

NOTSUPPORT(){
  print_error "Not Support ${OS} ${ARCH}\n"
  exit 1
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

help(){
  echo  -e "
Docker-LNMP CLI ${KHS1994_LNMP_DOCKER_VERSION}

Official WebSite https://lnmp.khs1994.com

Usage: ./docker-lnmp.sh COMMAND

Commands:
  acme.sh              Run original acme.sh command to issue SSL certificate
  backup               Backup MySQL databases
  build                Build or rebuild LNMP Self Build images (Only Support x86_64)
  build-config         Validate and view the LNMP Self Build images Compose file
  build-push           Build and Pushes images to Docker Registory
  build-up             Create and start LNMP containers With Self Build images (Only Support x86_64)
  cleanup              Cleanup log files
  compose              Install docker-compose
  development          Use LNMP in Development
  development-config   Validate and view the Development Compose file
  development-pull     Pull LNMP Docker Images in development
  daemon-socket        Expose Docker daemon on tcp://0.0.0.0:2375 without TLS on macOS
  down                 Stop and remove LNMP Docker containers, networks
  docs                 Read support documents
  full-up              Start Soft you input, all soft available
  help                 Display this help message
  init                 Init LNMP environment
  restore              Restore MySQL databases
  restart              Restart LNMP services
  registry             Start Docker Registry
  registry-down        Stop Docker Registry
  update               Upgrades LNMP
  upgrade              Upgrades LNMP

PHP Tools:
  httpd-config        Generate Apache2 vhost conf
  new                  New PHP Project and generate nginx conf and issue SSL certificate
  nginx-config         Generate nginx vhost conf
  ssl                  Issue SSL certificate powered by acme.sh, Thanks Let's Encrypt
  ssl-self             Issue Self-signed SSL certificate
  tp                   Create a new ThinkPHP application

Kubernets:
  dashboard            Print how run kubernetes dashboard in Dcoekr for Desktop

  k8s                  Deploy LNMP on k8s
  k8s-down             Remove k8s LNMP

Swarm mode:
  swarm-build          Build Swarm mode LNMP images (nginx php7)
  swarm-config         Validate and view the Swarm mode Compose file
  swarm-deploy         Deploy LNMP stack IN Swarm mode
  swarm-down           Remove LNMP stack IN Swarm mode
  swarm-ps             List the LNMP tasks
  swarm-pull           Pull LNMP Docker Images IN Swarm mode
  swarm-push           Push Swarm mode LNMP images (nginx php7)
  swarm-update         Print update LNMP service example

ClusterKit
  clusterkit [-d]              UP LNMP With Mysql Redis Memcached Cluster [Background]
  clusterkit-COMMAND           Run docker-compsoe commands(config, pull, etc)

  swarm-clusterkit             UP LNMP With Mysql Redis Memcached Cluster IN Swarm mode

  clusterkit-mysql-up          Up MySQL Cluster
  clusterkit-mysql-down        Stop MySQL Cluster
  clusterkit-mysql-exec        Execute a command in a running MySQL Cluster node

  clusterkit-mysql-deploy      Deploy MySQL Cluster in Swarm mode
  clusterkit-mysql-remove      Remove MySQL Cluster in Swarm mode

  clusterkit-redis-up          Up Redis Cluster
  clusterkit-redis-down        Stop Redis Cluster
  clusterkit-redis-exec        Execute a command in a running Redis Cluster node

  clusterkit-redis-deploy      Deploy Redis Cluster in Swarm mode
  clusterkit-redis-remove      Remove Redis Cluster in Swarm mode

Container CLI:
  SERVICE-cli                        Execute a command in a running LNMP container

LogKit:
  SERVICE-logs                       Print LNMP containers logs (journald)

Developer Tools:
  commit               Commit LNMP to Git
  cn-mirror            Push master branch to CN mirror
  dockerfile-update    Update Dockerfile By Script
  rc                   Start new release
  test                 Test LNMP

Read './docs/*.md' for more information about CLI commands.

You can open issue in [ https://github.com/khs1994-docker/lnmp/issues ] when you meet problems.

You must Update .env file when update this project.

Donate https://zan.khs1994.com
"
}

_registry(){

  # SSL 相关

  if [ ! -f config/nginx/ssl/${KHS1994_LNMP_REGISTRY_HOST}.crt ] || [ ! -f config/nginx/ssl/${KHS1994_LNMP_REGISTRY_HOST}.key ];then
    print_error "Docker Registry SSL not found, generating ...."
    ssl_self $KHS1994_LNMP_REGISTRY_HOST
  fi

  if [ ! -f config/nginx/ssl/${KHS1994_LNMP_REGISTRY_HOST}.crt ] || [ ! -f config/nginx/ssl/${KHS1994_LNMP_REGISTRY_HOST}.key ];then
    print_error "Docker Registry SSL error"
    exit 1
  else
    print_info "Docker Registry SSL Correct"
  fi

  # 生成 密码 验证文件

  if ! [ -f config/nginx/auth/docker_registry.htpasswd ];then
    echo; print_info "First start, Please set username and password"
    read -p "username: " username
    if [ -z $username ];then echo; print_error "用户名不能为空"; exit 1; fi
    read -s -p "password: " password; echo
    if [ -z $password ];then echo; print_error "密码不能为空"; exit 1; fi
    read -s -p "Please reinput password: " password_verify; echo; echo

    if ! [ "$password" = "$password_verify" ];then
      print_error "两次输入的密码不同，请再次执行 ./lnmp-docker.sh registry 完成操作"; exit 1
    fi

    docker run --rm \
      --entrypoint htpasswd \
      registry \
      -Bbn $username $password > config/nginx/auth/docker_registry.htpasswd
      # 部分 nginx 可能不能解密，你可以替换为下面的命令
      # -mbn username password > auth/nginx.htpasswd \
  fi

  # NGINX 配置文件

  if ! [ -f config/nginx/registry.conf ];then
    if [ -f config/nginx/registry.conf.backup ];then
      cp config/nginx/registry.conf.backup config/nginx/registry.conf
    else
      cp config/nginx/demo-registry.conf.backup config/nginx/registry.conf
    fi
  fi

  sed -i '' "s#KHS1994_DOMAIN#${KHS1994_LNMP_REGISTRY_HOST}#g" config/nginx/registry.conf

  exec docker-compose -f docker-full.yml -f docker-compose.override.yml up -d registry nginx
}

_registry_down(){
  docker-compose -f docker-full.yml -f docker-compose.override.yml stop registry
  docker-compose -f docker-full.yml -f docker-compose.override.yml rm -f registry
  mv config/nginx/registry.conf config/nginx/registry.conf.backup
}

tz(){
  local image=nginx:1.13.8-alpine

  if [ ${ARCH} = "armv7l" ];then NOTSUPPORT; fi
  if [ ${ARCH} = "aarch64" ];then local image=khs1994/arm64v8-php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7; fi

  docker volume inspect lnmp_zoneinfo-data > /dev/null 2>&1
  if ! [ "$?" = 0 ];then
  print_info "Create TZDATA Volume...\n"
      docker run -it --rm \
          --mount src=lnmp_zoneinfo-data,target=/usr/share/zoneinfo \
          $image \
          date > /tmp/tzdata.txt 2>&1
  fi
}

env_status(){
  # cp .env.example to .env
  if [ -f .env ];then print_info ".env file existing\n"; else print_error ".env file NOT existing\n"; cp .env.example .env ; fi
  if [ -f cluster/.env ];then print_info "cluster/.env file existing\n"; else print_error "cluster/.env file NOT existing\n"; cp cluster/.env.example cluster/.env ; fi
}

# 自动升级软件版本

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

# Docker 是否运行

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

# 创建日志文件

logs(){
  if ! [ -d logs/httpd ];then mkdir -p logs/httpd; fi

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
      && rm -rf logs/httpd/* \
      && echo > logs/php-fpm/php/error.log
      print_info "Clean log files SUCCESS\n"
}

gitbook(){
  docker rm -f lnmp-docs
  exec docker run -it --rm \
    -p 4000:4000 \
    --name lnmp-docs \
    -v $PWD/docs:/srv/gitbook-src \
    khs1994/gitbook \
    server
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
      sed -i '' "s#^    image: khs1994/nginx.*#    image: khs1994/nginx:swarm-$VERSION-alpine#g" docker-k8s.yml ${PRODUCTION_COMPOSE_FILE} linuxkit/lnmp.yml
      ;;
    mysql )
      sed -i '' "s#^KHS1994_LNMP_MYSQL_VERSION.*#KHS1994_LNMP_MYSQL_VERSION=${VERSION}#g" .env.example .env
      sed -i '' "s#^    image: mysql.*#    image: mysql:$VERSION#g" docker-k8s.yml ${PRODUCTION_COMPOSE_FILE} linuxkit/lnmp.yml
      ;;
    php-fpm )
      sed -i '' "s#^KHS1994_LNMP_PHP_VERSION.*#KHS1994_LNMP_PHP_VERSION=${VERSION}#g" .env.example .env
      sed -i '' "s#^    image: khs1994/php-fpm.*#    image: khs1994/php-fpm:swarm-$VERSION-alpine3.7#g" docker-k8s.yml ${PRODUCTION_COMPOSE_FILE} linuxkit/lnmp.yml
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
      sed -i '' "s#^    image: redis.*#    image: redis:$VERSION-alpine#g" docker-k8s.yml ${PRODUCTION_COMPOSE_FILE} linuxkit/lnmp.yml
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
  ping -c 3 -W 3 baidu.com > /dev/null 2>&1 || ( print_error "Network connection error" ;exit 1)
}

# 更新项目

set_git_remote_lnmp_url(){
  network
  git remote get-url lnmp > /dev/null 2>&1
  if [ $? -ne 0 ];then
    # 不存在
    print_error "This git remote lnmp NOT set, seting..."
    git remote add lnmp git@github.com:khs1994-docker/lnmp.git
    # 不能使用 SSH
    git fetch lnmp > /dev/null 2>&1 || git remote set-url lnmp https://github.com/khs1994-docker/lnmp
    print_info `git remote get-url lnmp`
  elif [ `git remote get-url lnmp` != 'git@github.com:khs1994-docker/lnmp.git' ] && [ `git remote get-url lnmp` != 'https://github.com/khs1994-docker/lnmp' ];then
    # 存在但是设置错误
    print_error "This git remote lnmp NOT set Correct, reseting..."
    git remote rm lnmp
    git remote add lnmp git@github.com:khs1994-docker/lnmp.git
    # 不能使用 SSH
    git fetch  lnmp > /dev/null 2>&1 || git remote set-url lnmp https://github.com/khs1994-docker/lnmp
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
  if [ ! -z "${GIT_STATUS}" ] && [ ! "$force" = 'true' ];then
     git status -s --ignore-submodules
     echo; print_error "Please commit then update"
     exit 1
  fi
  git fetch lnmp
  print_info "Branch is ${BRANCH}\n"
  if [ ${BRANCH} = 'dev' ] || [ ${BRANCH} = 'master' ];then
    git submodule update --init --recursive
    git reset --hard lnmp/${BRANCH}
  else
    print_error "${BRANCH} error，Please checkout to dev or master branch\n\n$ git checkout dev\n "
  fi
  command -v bash > /dev/null 2>&1
  if ! [ $? = 0  ];then sed -i 's!^#\!/bin/bash.*!#\!/bin/sh!g' lnmp-docker.sh; fi
  # 升级软件版本
  update_version
}

# 提交项目「开发者选项」

commit(){
  # 检查网络连接
  network
  print_info `git remote get-url origin` ${BRANCH}
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
    git submodule update --init --recursive
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

  ErrorLog \"logs/$1.error.log\"
  CustomLog \"logs/$1.access.log\" common

  <FilesMatch \.php$>
    SetHandler \"proxy:fcgi://php7:9000\"
  </FilesMatch>

  <Directory \"/app/$2\" >
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>

</VirtualHost>" >> config/httpd/$1.conf
}

apache_https(){
  echo "#
# Generate Apache2 HTTPS config By khs1994-docker/lnmp
#

<VirtualHost *:443>
  DocumentRoot \"/app/$2\"
  ServerName $1
  ServerAlias $1

  ErrorLog \"logs/$1.error.log\"
  CustomLog \"logs/$1.access.log\" common

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
    AllowOverride All
    Require all granted
  </Directory>

</VirtualHost>" >> config/httpd/$1.conf
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
  ssl_protocols              TLSv1.2 TLSv1.3;
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

acme(){
  exec docker run -it --rm \
         -v $PWD/config/nginx/ssl:/ssl \
         --mount source=lnmp_ssl-data,target=/root/.acme.sh \
         --env-file .env \
         khs1994/acme:${ACME_VERSION} acme.sh "$@"
}

ssl(){
  if [ -z "$DP_Id" ];then print_error "Please set DNS API ENV in .env file"; exit 1; fi
  if [ -z "$1" ];then
    exec echo "command example

$ ./lnmp-docker.sh ssl khs1994.com

$ ./lnmp-docker.sh ssl khs1994.com -d www.khs1994.com -d t.khs1994.com

通配符证书（测试）

$ ./lnmp-docker.sh ssl khs1994.com -d *.khs1994.com -d t.khs1994.com -d *.t.khs1994.com
"
  fi
  exec docker run -it --rm \
         -v $PWD/config/nginx/ssl:/ssl \
         --mount source=lnmp_ssl-data,target=/root/.acme.sh \
         --env-file .env \
         -e DP_Id=${DP_Id} \
         -e DP_Key=${DP_Key} \
         khs1994/acme:${ACME_VERSION} "$@"
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

# 入口文件

main() {
  tz
  logs
  local command=$1; shift
  case $command in
  acme.sh )
    run_docker; acme "$@"
    ;;

  init )
    init
    ;;

  backup )
    run_docker; backup "$@"
    ;;

  development-config )
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

  registry )
    _registry
    ;;

  registry-down )
    _registry_down
    ;;

  full-up )
    docker-compose -f docker-full.yml -f docker-compose.override.yml up -d "$@"
    ;;

  # production )
  #   run_docker
  #   # 仅允许运行在 Linux x86_64
  #   if [ "$OS" = 'Linux' ] && [ ${ARCH} = 'x86_64' ];then
  #     init
  #     if ! [ "$1" = "--systemd" ];then opt='-d'; else opt= ; fi
  #     docker-compose -f docker-compose.yml -f docker-compose.prod.yml up $opt
  #     echo; sleep 2; print_info "Test nginx configuration file...\n"
  #     docker-compose -f docker-compose.yml -f docker-compose.prod.yml exec nginx nginx -t
  #     if [ $? = 0 ];then
  #       echo; print_info "nginx configuration file test is successful\n" ; exit 0
  #     else
  #       echo; print_error "nginx configuration file test failed, You must check nginx configuration file!"; exit 1
  #     fi
  #   else
  #     print_error "Production NOT Support ${OS} ${ARCH}\n"
  #   fi
  #   ;;

  swarm-config )
    init; exec docker-compose -f ${PRODUCTION_COMPOSE_FILE} config
    ;;

  swarm-pull )
    run_docker
    # 仅允许运行在 Linux x86_64
    if [ "$OS" = 'Linux' ] && [ ${ARCH} = 'x86_64' ];then
      init; sleep 2; exec docker-compose -f ${PRODUCTION_COMPOSE_FILE} pull "$@"
    else
      print_error "Production NOT Support ${OS} ${ARCH}\n"
    fi
    ;;

  swarm-build )
    docker-compose -f ${PRODUCTION_COMPOSE_FILE} build "$@"
    ;;

  swarm-push )
    docker-compose -f ${PRODUCTION_COMPOSE_FILE} push "$@"
    ;;

  swarm-deploy )
    if [ "$OS" = 'Linux' ] && [ ${ARCH} = 'x86_64' ];then
      run_docker
      docker stack deploy -c ${PRODUCTION_COMPOSE_FILE} lnmp

      if [ $? -eq 0 ];then sleep 2; docker stack ps lnmp; else exit 1; fi

    else
      print_error "Production NOT Support ${OS} ${ARCH}\n"
    fi
    ;;

  swarm-down )
    docker stack rm lnmp
    ;;

  swarm-ps )
    docker stack ps lnmp
    ;;

  swarm-update )
  echo -e "
Example:


$ docker config create nginx_khs1994_com_conf_v2 config/nginx/khs1994.com.conf

$ docker service update \\
    --config-rm nginx_khs1994_com_conf \\
    --config-add source=nginx_khs1994_com_conf_v2,target=/etc/nginx/conf.d/khs1994.com.conf \\
    lnmp_nginx

$ docker secret create khs1994_com_ssl_crt_v2 config/nginx/ssl/khs1994.com.crt

$ docker service update \\
    --secret-rm khs1994_com_ssl_crt \\
    --secret-add source=khs1994_com_ssl_crt_v2,target=/etc/nginx/conf.d/ssl/khs1994.com.crt \\
    lnmp_nginx

$ docker service update --image nginx:1.13.9 lnmp_nginx

For information please run $ docker service update --help
"
  ;;

  build )
    run_docker
    init

    if [ ${ARCH} = 'x86_64' ];then
      exec docker-compose -f docker-compose.yml -f docker-compose.build.yml build "$@"
    else
      NOTSUPPORT
    fi

    ;;

  build-up )
    run_docker
    init

    if [ ${ARCH} = 'x86_64' ];then
      exec docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d "$@"
    else
      NOTSUPPORT
    fi

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
      docker-compose -f docker-arm.yml up $opt
      echo; sleep 1; print_info "Test nginx configuration file...\n"
      docker-compose -f docker-arm.yml exec nginx nginx -t
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

  nginx-config )
     if [ -z "$3" ];then print_error "$ ./lnmp-docker.sh nginx-config {https|http} {PATH} {URL}"; exit 1; fi
     print_info 'Please set hosts in /etc/hosts in development\n'
     print_info 'Maybe you need generate nginx HTTPS conf in website https://khs1994-website.github.io/server-side-tls/ssl-config-generator/'
     if [ "$1" = 'http' ];then shift; nginx_http $2 $1; fi
     if [ "$1" = 'https' ];then shift; nginx_https $2 $1; fi
     echo
     print_info "You must checkout ./config/nginx/$2.conf, then restart nginx"
     ;;

  httpd-config )
    if [ -z "$3" ];then print_error "$ ./lnmp-docker.sh apache-config {https|http} {PATH} {URL}"; exit 1; fi
    print_info 'Please set hosts in /etc/hosts in development\n'
    print_info 'Maybe you need generate Apache2 HTTPS conf in website https://khs1994-website.github.io/server-side-tls/ssl-config-generator/'
    if [ "$1" = 'http' ];then shift; apache_http $2 $1; fi
    if [ "$1" = 'https' ];then shift; apache_https $2 $1; fi
    echo
    print_info "You must checkout ./config/httpd/$2.conf, then restart httpd"
    ;;

  php-cli )
    run_docker; docker-compose exec php7 bash
    ;;

  mongodb-cli | mongo-cli )
    run_docker; docker-compose exec mongodb bash
    ;;

  mariadb-cli )
    run_docker; docker-compose exec mariadb bash
    ;;

  mysql-cli )
    run_docker; docker-compose exec mysql bash
    ;;

  *-cli )
    SERVICE=$(echo $command | cut -d '-' -f 1)
    run_docker; docker-compose exec $SERVICE sh
    ;;

  *-logs | *-log )

    if ! [ "${OS}" = 'Linux' ];then NOTSUPPORT; fi

    SERVICE=$(echo $command | cut -d '-' -f 1)
    journalctl -u docker.service CONTAINER_ID=$(docker container ls --format "{{.ID}}" -f label=com.khs1994.lnmp.$SERVICE) "$@"
    ;;

  build-push )
    run_docker; init; exec docker-compose -f docker-compose.build.yml build && docker-compose -f docker-compose.build.yml push
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

  development-pull )
    run_docker; init
    case "${ARCH}" in
        x86_64 )
          sleep 2; exec docker-compose pull
          ;;
        aarch64 | armv7l )
          sleep 2; exec docker-compose -f docker-arm.yml pull
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
    run_docker; ssl "$@"
    ;;

  ssl-self )
    if [ -z "$1" ];then
      print_error '$ ./lnmp-docker.sh ssl-self {IP|DOMAIN}'
      echo -e "
Example:

$ ./lnmp-docker.sh ssl-self khs1994.com 127.0.0.1 192.168.199.100 localhost ...

$ ./lnmp-docker.sh ssl-self khs1994.com *.khs1994.com t.khs1994.com *.t.khs1994.com 127.0.0.1 192.168.199.100 localhost ...
"
    exit 1
    fi
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
    cd app
    ../bin/lnmp-composer create-project topthink/think=5.0.* ${path} --prefer-dist ${cmd}
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

  clusterkit )
     docker-compose -f docker-compose.yml \
       -f docker-compose.override.yml \
       -f docker-cluster.mysql.yml \
       -f docker-cluster.redis.yml \
       up "$@"
     ;;

  clusterkit-mysql-up )
     docker-compose -f docker-cluster.mysql.yml up "$@"
     ;;

  clusterkit-mysql-down )
     docker-compose -f docker-cluster.mysql.yml down "$@"
     ;;

  clusterkit-mysql-exec )
     NODE=$1
     shift
     COMMAND=$@
     if [ -z $@ ];then
       print_error '$ ./lnmp-docker.sh clusterkit-mysql-exec {master|node1|node2} {COMMAND}'
     fi
     docker exec -it $(docker container ls --format "{{.ID}}" --filter label=com.khs1994.lnmp.clusterkit.mysql=${NODE}) $COMMAND
     ;;

  clusterkit-mysql-deploy )
       docker stack deploy -c docker-cluster.mysql.yml mysql_cluster
        ;;
  clusterkit-mysql-remove )
       docker stack rm mysql_cluster
        ;;

  clusterkit-redis-up )
        docker-compose -f docker-cluster.redis.yml up "$@"
        ;;

  clusterkit-redis-down )
        docker-compose -f docker-cluster.redis.yml down "$@"
        ;;

  clusterkit-redis-exec )
        NODE=$1
        shift
        COMMAND=$@
        if [ -z $@ ];then
          print_error '$ ./lnmp-docker.sh clusterkit-redis-exec {master1|slave1} {COMMAND}'
        fi
        docker exec -it $(docker container ls --format "{{.ID}}" --filter label=com.khs1994.lnmp.clusterkit.redis=${NODE}) $COMMAND
        ;;

  clusterkit-* )
        command=$(echo $command | cut -d '-' -f 2)
        exec docker-compose -f docker-compose.yml \
             -f docker-compose.override.yml \
             -f docker-cluster.mysql.yml \
             -f docker-cluster.redis.yml \
             $command "$@"
        ;;

  swarm-clusterkit )
    docker stack deploy -c docker-production.yml -c docker-cluster.mysql.yml lnmp
        ;;

  dashboard )
    echo -e "
$ cd kubernetes

$ kubectl apply -f kubernetes-dashboard.yaml

$ kubectl proxy

OPEN http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
"
    print_info "More information please see https://github.com/kubernetes/dashboard"

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

ARCH=`uname -m`

OS=`uname -s`

COMPOSE_LINK_OFFICIAL=https://github.com/docker/compose/releases/download

COMPOSE_LINK=https://code.aliyun.com/khs1994-docker/compose-cn-mirror/raw

# 获取正确版本号

env_status

. .env ; . cli/.env ; . /tmp/.khs1994.env > /dev/null 2>&1 ; rm -rf /tmp/.khs1994.env

if [ -d .git ];then BRANCH=`git rev-parse --abbrev-ref HEAD`; fi

if [ "$1" = "development" ] || [ "$1" = "production" ];then APP_ENV=$1; fi

# 写入版本号

if [ ${OS} = "Darwin" ];then
  sed -i "" "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" .env
else
  sed -i "s/^KHS1994_LNMP_DOCKER_VERSION.*/KHS1994_LNMP_DOCKER_VERSION=${KHS1994_LNMP_DOCKER_VERSION}/g" .env
fi

if [ ${ARCH} = 'armv7l' ];then
    sed -i "s/^ARM_ARCH.*/ARM_ARCH=arm32v7/g" .env
    sed -i "s/^ARM_PHP_BASED_OS.*/ARM_PHP_BASED_OS=stretch/g" .env
    sed -i "s/^ARM_BASED_OS.*/ARM_BASED_OS=/g" .env
elif [ ${ARCH} = 'aarch64' ];then
    sed -i "s/^ARM_ARCH.*/ARM_ARCH=arm64v8/g" .env
    sed -i "s/^ARM_PHP_BASED_OS.*/ARM_PHP_BASED_OS=alpine3.7/g" .env
fi

print_info "ARCH is ${OS} ${ARCH}\n"

print_info `docker --version`

echo; docker_compose

if [ $# = 0 ];then help; exit 0; fi

# 生产环境 compose 文件

ls docker-production.*.yml > /dev/null 2>&1

if [ $? = '0' ];then
  PRODUCTION_COMPOSE_FILE=`ls docker-production.*.yml`
else
  PRODUCTION_COMPOSE_FILE='docker-production.yml'
fi

main "$@"
