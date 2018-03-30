#!/usr/bin/env bash

#
# 从 Docker 复制二进制文件，安装 PHP Redis Memcached
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

  if ! [ -h /etc/nginx/conf.d ];then rm -rf /etc/nginx/conf.d; ln -s $WSL_HOME/lnmp/wsl/nginx /etc/nginx/conf.d; fi

}

_php(){
  # include redis memcached
docker pull registry.cn-hangzhou.aliyuncs.com/khs1994/wsl

docker run -dit --name=${CONTAINER_NAME} registry.cn-hangzhou.aliyuncs.com/khs1994/wsl #khs1994/php-fpm:wsl

sudo rm -rf /usr/local/php72

sudo docker -H 127.0.0.1:2375 cp ${CONTAINER_NAME}:/wsl-php72.tar.gz /usr/local/

docker rm -f ${CONTAINER_NAME}

cd /usr/local

sudo tar -zxvf wsl-php72.tar.gz

cd /var/log

if ! [ -f php72-fpm.error.log ];then sudo touch php72-fpm.error.log ; fi
if ! [ -f php72-fpm.access.log ];then sudo touch php72-fpm.access.log ; fi
if ! [ -f php72-fpm.slow.log ];then sudo touch php72-fpm.slow.log; fi

sudo chmod 777 php72-*

sudo cp $WSL_HOME/lnmp/config/php/php.development.ini /usr/local/php72/etc/php.ini

for file in $( ls /usr/local/php72/bin ); do sudo ln -sf /usr/local/php72/bin/$file /usr/local/bin/ ; done

sudo ln -sf /usr/local/php72/sbin/php-fpm /usr/local/sbin

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
  #
  # @link https://www.postgresql.org/download/linux/debian/

 if ! [ -f /etc/apt/sources.list.d/postgresql.list ];then
    echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list
  fi

  apt-key list | grep PostgreSQL || wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

  sudo apt-get update

  sudo apt-get -y install postgresql
}

_rabbitmq(){
  # apt
  echo
}

_mongodb(){
  # apt
  #
  # @link https://docs.mongodb.com/master/tutorial/install-mongodb-on-debian/
  sudo apt install mongodb
}

_list(){
  # list php extension
  cd /usr/local/src/php-7.2.4/ext
  set +x
  for ext in `ls`; do echo '*' $( php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ); done
}

if ! [ -z "$1" ];then

for c in "$@"; do _$c; done;

fi
