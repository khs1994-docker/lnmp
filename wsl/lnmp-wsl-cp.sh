#!/usr/bin/env bash

set -ex

. /etc/os-release

if ! [ $ID = debian ];then exit 1; fi

CONTAINER_NAME=$( date +%s )

_nginx(){
  # apt
  if ! [ -f /etc/apt/sources.list.d/nginx.list ];then
    echo "deb http://nginx.org/packages/mainline/debian stretch nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
  fi

  apt-key list | grep nginx || curl -fsSL http://nginx.org/packages/keys/nginx_signing.key | sudo apt-key add -

  sudo apt update

  sudo apt install nginx
}

_php(){
  # include redis memcached
docker run -dit --name=${CONTAINER_NAME} khs1994/php-fpm:wsl

sudo rm -rf /usr/local/php72

sudo docker -H 127.0.0.1:2375 cp ${CONTAINER_NAME}:/usr/local/php72 /usr/local/php72/

docker rmi ${CONTAINER_NAME}
}

_httpd(){

docker run -dit --name=${CONTAINER_NAME} httpd:2.4.33

rm -rf /usr/local/apache2

sudo cp ${CONTAINER_NAME}:/usr/local/apache2 /usr/local/apache2

docker rmi ${CONTAINER_NAME}
}

_postgresql(){
  # apt
  echo
}

if ! [ -z "$1" ];then

_$1

fi
