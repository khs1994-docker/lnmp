#!/bin/bash

# 安装 docker-compose

which docker-compose
if [ $? = 0 ];then
  #存在
  docker-compose --version
  echo -e "\033[32mINFO\033[0m  docker-compose already installed\n"
else
  echo -e "\033[32mINFO\033[0m  docker-compose is installing...\n"
  # https://api.github.com/repos/docker/compose/releases/latest
  DOCKER_COMPOSE_VERSION=1.16.1
  curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
  chmod +x docker-compose
  echo $PATH
  sudo mv docker-compose /usr/local/bin
fi
echo -e "\033[32mINFO\033[0m mkdir log folder\n"

# 创建日志文件

rm -rf logs/*

mkdir -p logs/nginx/
cd logs/nginx
touch error.log access.log
cd -

mkdir -p logs/php-fpm
cd logs/php-fpm
touch error.log access.log xdebug-remote.log
cd -

mkdir -p logs/mysql
cd logs/mysql
touch error.log
cd -

echo -e "\n\033[32mINFO\033[0m mkdir log folder SUCCESS\n"

# 初始化完成提示

# 构建镜像

cd dockerfile/laravel-artisan/

docker build -t lnmp-laravel-artisan .

echo -e "\033[32mINFO\033[0m  inin is SUCCESS please RUN \" docker-compose up -d \""
