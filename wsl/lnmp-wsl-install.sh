#!/usr/bin/env bash

#
# 从 Docker 复制二进制文件，安装 PHP Redis Memcached
#
# Only Support WSL Debian
#
# $ lnmp-wsl-install.sh php [deb | tar] [7.2.4]
#

if [ -z "$1" ];then
  exec echo "

Install WSL soft by shell script


Usage:

$ lnmp-wsl-install.sh php 7.2.4 [ tar | deb ]

$ lnmp-wsl-install.sh enable [ php72 | php71 | php70 | php56 ]

$ lnmp-wsl-install.sh nginx php postgresql mysql mongodb ...

"
fi

set -ex

. /etc/os-release

. ~/.bash_profile || echo

################################################################################

if [ -z $WSL_HOME ];then exit 1 ; fi

################################################################################

CONTAINER_NAME=$( date +%s )

_nginx(){
  # apt
  if ! [ -f /etc/apt/sources.list.d/nginx.list ];then
    echo "deb http://nginx.org/packages/mainline/${ID} $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
  fi

  apt-key list | grep nginx || curl -fsSL http://nginx.org/packages/keys/nginx_signing.key | sudo apt-key add -

  sudo apt update

  sudo apt install -y nginx

  if ! [ -h /etc/nginx/conf.d ];then sudo rm -rf /etc/nginx/conf.d; sudo ln -sf $WSL_HOME/lnmp/wsl/nginx /etc/nginx/conf.d; fi

  if ! [ -f /etc/nginx/fastcgi.conf ];then sudo cp $WSL_HOME/lnmp/config/etc/nginx/fastcgi.conf /etc/nginx/fastcgi.conf ; fi

  sudo nginx -T | grep "fastcgi_buffering off;" || sudo cp $WSL_HOME/lnmp/wsl/nginx.wsl.conf /etc/nginx/nginx.conf

  sudo nginx -t

}

_php(){
  command -v docker || echo -e "Docker cli not install, you can exec $ lnmp-wsl-docker-cli.sh "

  command -v docker || exit 1
  # include redis memcached
  # default install latest php version
  # current version is php 7.2.4
  PHP_VERSION=${1:-7.2.4}

################################################################################

  case ${PHP_VERSION} in
    5.6.* )
      export PHP_NUM=56
      if [ $ID = debian ];then set +x ; echo -e   "\n\nkhs1994-wsl-php only support php56 on Ubuntu, you can self build use $ lnmp-wsl-php-builder.sh\n\n" ; exit 1; fi
      ;;

    7.0.* )
      if ! [ $ID = debian ];then set +x ; echo -e "\n\nkhs1994-wsl-php only support php70 on Debian9, you can self build use $ lnmp-wsl-php-builder.sh \n\n" ; exit 1; fi
      export PHP_NUM=70
      ;;

    7.1.* )
      if ! [ $ID = debian ];then set +x ; echo -e "\n\nkhs1994-wsl-php only support php71 on Debian9, you can self build use $ lnmp-wsl-php-builder.sh\n\n" ; exit 1; fi
      export PHP_NUM=71
      ;;

    7.2.* )
      if ! [ $ID = debian ];then set +x ; echo -e "\n\nkhs1994-wsl-php only support php72 on Debian9, you can self build use $ lnmp-wsl-php-builder.sh\n\n" ; exit 1; fi
      export PHP_NUM=72
      ;;

    * )
      echo "ONLY SUPPORT 5.6 +"
      exit 1
  esac

################################################################################

  PHP_PREFIX=/usr/local/php${PHP_NUM}
  PHP_INI_DIR=/usr/local/etc/php${PHP_NUM}

_tar(){
docker pull registry.cn-hangzhou.aliyuncs.com/khs1994/wsl

docker create --name=${CONTAINER_NAME} registry.cn-hangzhou.aliyuncs.com/khs1994/wsl #khs1994/php-fpm:wsl

# rm
sudo rm -rf ${PHP_PREFIX}

sudo docker -H 127.0.0.1:2375 cp ${CONTAINER_NAME}:/wsl-php${PHP_NUM}.tar.gz /usr/local/
sudo docker -H 127.0.0.1:2375 cp ${CONTAINER_NAME}:/wsl-php${PHP_NUM}-etc.tar.gz /usr/local/etc/

docker rm -f ${CONTAINER_NAME}

cd /usr/local

sudo tar -zxvf wsl-php${PHP_NUM}.tar.gz

sudo rm -rf wsl-php${PHP_NUM}.tar.gz

cd /usr/local/etc

# backup
if [ -d ${PHP_INI_DIR} ];then
  sudo mv ${PHP_INI_DIR} ${PHP_INI_DIR}.$( date +%s ).backup
fi

sudo tar -zxvf wsl-php${PHP_NUM}-etc.tar.gz

sudo rm -rf wsl-php${PHP_NUM}-etc.tar.gz

# log
cd /var/log

if ! [ -f php${PHP_NUM}.error.log ];then sudo touch php${PHP_NUM}.error.log ; fi
if ! [ -f php${PHP_NUM}-fpm.error.log ];then sudo touch php${PHP_NUM}-fpm.error.log ; fi
if ! [ -f php${PHP_NUM}-fpm.access.log ];then sudo touch php${PHP_NUM}-fpm.access.log ; fi
if ! [ -f php${PHP_NUM}-fpm.slow.log ];then sudo touch php${PHP_NUM}-fpm.slow.log; fi

sudo chmod 777 php${PHP_NUM}*

# ln
for file in $( ls ${PHP_PREFIX}/bin ); do sudo ln -sf ${PHP_PREFIX}/bin/$file /usr/local/bin/ ; done

sudo ln -sf ${PHP_PREFIX}/sbin/php-fpm /usr/local/sbin

lnmp-wsl-php-builder.sh apt
}

_deb(){
    cd /tmp

    DEB_NAME=khs1994-wsl-php_${PHP_VERSION}-${ID}-$( lsb_release -cs )_amd64

    sudo rm -rf ${DEB_NAME}.deb

    docker pull khs1994/wsl:${DEB_NAME}

    docker create --name=${CONTAINER_NAME} khs1994/wsl:${DEB_NAME}

    sudo docker -H 127.0.0.1:2375 cp ${CONTAINER_NAME}:/${DEB_NAME}.deb .

    docker rm -f ${CONTAINER_NAME}

    sudo dpkg -i ${DEB_NAME}.deb || ( sudo apt install -f && sudo dpkg -i ${DEB_NAME}.deb )
}

rpm(){
  cd /tmp

  RPM_NAME=khs1994-wsl-php-${PHP_VERSION}-1.el${VERSION_ID}.centos.x86_64.rpm

  DOCKER_IMAGE_NAME=khs1994-wsl-php_${PHP_VERSION}-${ID}-${VERSION_ID}_amd64

  sudo rm -rf ${RPM_NAME}

  docker pull khs1994/wsl:${DOCKER_IMAGE_NAME}

  docker create --name=${CONTAINER_NAME} khs1994/wsl:${DOCKER_IMAGE_NAME}

  sudo docker -H 127.0.0.1:2375 cp ${CONTAINER_NAME}:/${RPM_NAME} .

  docker rm -f ${CONTAINER_NAME}

  sudo yum install -y ${RPM_NAME}
}

if [ -z "$2" ];then

echo -e "install by tar"

_tar || set +x echo -e "\n\nInstall by Tar only support php72 and latest\n\n"

else

echo -e "install by $2"

_"$2"

fi

echo "##########################################################################"

php -v

php-fpm -v

echo "##########################################################################"

php -i | grep .ini

# composer cn mirror

command -v /usr/local/bin/composer && composer config -g repo.packagist composer https://packagist.phpcomposer.com

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
# docker create --name=${CONTAINER_NAME} httpd:2.4.33
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
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $( lsb_release -cs )-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list
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

_mysql(){
  # apt
  if ! [ -f mysql-apt-config_0.8.9-1_all.deb ];then
      wget https://dev.mysql.com/get/mysql-apt-config_0.8.9-1_all.deb
  fi

  sudo dpkg -i mysql-apt-config_0.8.9-1_all.deb
  sudo apt install -f
  sudo apt update
  sudo apt install mysql-server
}

_list(){
  # list php extension
  cd /usr/local/src/php-7.2.4/ext
  set +x
  for ext in `ls`; do echo '*' $( php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ); done
}

_enable(){

  PHP_PREFIX=/usr/local/$1

  php_num=$( echo $1 | cut -d 'p' -f 3 )

  if ! [ -d ${PHP_PREFIX} ];then echo -e "\n\n$1 is not install\n\n"; exit 1; fi

  for file in $( ls ${PHP_PREFIX}/bin ); do sudo ln -sf ${PHP_PREFIX}/bin/$file /usr/local/bin/ ; done

  sudo ln -sf ${PHP_PREFIX}/sbin/php-fpm /usr/local/sbin

  sudo sed -i "s#/var/run/php${php_num}-fpm.sock#/var/run/php-fpm.sock#g" /usr/local/php${php_num}/etc/php-fpm.d/zz-${ID}.conf

  sudo sed -i "s#/var/run/php${php_num}-fpm.pid#/var/run/php-fpm.pid#g" /usr/local/php${php_num}/etc/php-fpm.d/zz-${ID}.conf
}

if [ "$1" = 'enable' ];then shift ; _enable "$@"; exit $?; fi

if [ "$1" = "php" ];then shift ; _php "$@"; exit $?; fi

if ! [ -z "$1" ];then

for c in "$@"; do _$c; done;

fi
