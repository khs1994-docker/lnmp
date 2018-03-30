#!/usr/bin/env bash

#
# 从 Docker 复制二进制文件安装 PHP Redis Memcached 软件
#

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

  sudo apt install -y nginx
}

_php(){
  # include redis memcached
docker run -dit --name=${CONTAINER_NAME} registry.cn-hangzhou.aliyuncs.com/khs1994/wsl #khs1994/php-fpm:wsl

sudo rm -rf /usr/local/php72

sudo docker -H 127.0.0.1:2375 cp ${CONTAINER_NAME}:/wsl-php72.tar.gz /usr/local/

docker rm -f ${CONTAINER_NAME}

cd /usr/local

sudo -zxvf wsl-php72.tar.gz

cd /var/log

if ! [ -f php72-fpm.error.log ];then sudo touch php72-fpm.error.log ; fi
if ! [ -f php72-fpm.access.log ];then sudo touch php72-fpm.access.log ; fi
if ! [ -f php72-fpm.slow.log ];then sudo touch php72-fpm.slow.log; fi

sudo chmod 777 php72-*

cp $WSL_HOME/lnmp/config/php/php.development.ini /usr/local/php72/etc/

php -v

php-fpm -v

}

# _httpd(){
#
# NGHTTP2_VERSION=1.18.1-1
# OPENSSL_VERSION=1.0.2l-1~bpo8+1
#
# sudo apt install -y --no-install-recommends \
# 		libapr1 \
# 		libaprutil1 \
# 		libaprutil1-ldap \
# 		libapr1-dev \
# 		libaprutil1-dev \
# 		liblua5.2-0 \
# 		libnghttp2-14=$NGHTTP2_VERSION \
# 		libpcre++0 \
# 		libssl1.0.0=$OPENSSL_VERSION \
#     libxml2
#
# docker run -dit --name=${CONTAINER_NAME} httpd:2.4.33
#
# sudo rm -rf /usr/local/apache2
#
# sudo docker -H 127.0.0.1:2375 cp ${CONTAINER_NAME}:/usr/local/apache2 /usr/local/apache2
#
# docker rm -f ${CONTAINER_NAME}
# }

_postgresql(){
  # apt
  echo
}

_rabbitmq(){
  # apt
  echo
}

_mongodb(){
  # apt
  echo
}

_list(){
  # list php extension
  cd /usr/local/src/php-7.2.4/ext
  set +x
  for ext in `ls`; do echo '*' $( php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ); done
}

if ! [ -z "$1" ];then

_$1

fi
