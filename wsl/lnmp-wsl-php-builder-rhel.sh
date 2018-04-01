#！/bin/bash

set -ex

#
# Build php in WSL(Debian Ubuntu)
#

command -v wget || ( sudo yum -y update && sudo yum install wget -y)

# epel

sudo wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sudo rpm -Uvh epel-release*rpm

#

PHP_URL=http://cn2.php.net/distributions

mkdir -p /tmp/php-builder || echo

PHP_INSTALL_LOG=/tmp/php-builder/$(date +%s).install.log

PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
PHP_CPPFLAGS="$PHP_CFLAGS"
PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

export CFLAGS="$PHP_CFLAGS"
export CPPFLAGS="$PHP_CPPFLAGS"
export LDFLAGS="$PHP_LDFLAGS"

if ! [ -z "$1" ];then
  export PHP_VERSION=$1
else
  read -p "Please input php version: [7.2.4] " PHP_VERSION
fi

PHP_VERSION=${PHP_VERSION:-7.2.4}

if [ $PHP_VERSION = 'yum' ];then PHP_VERSION=7.2.4; fi

case ${PHP_VERSION} in
  5.6.* )
    export PHP_NUM=56
    export PHP_ROOT=/usr/local/php56
    ;;

  7.0.* )
    export PHP_NUM=70
    export PHP_ROOT=/usr/local/php70
    ;;

  7.1.* )
    export PHP_NUM=71
    export PHP_ROOT=/usr/local/php71
    ;;

  7.2.* )
    export PHP_NUM=72
    export PHP_ROOT=/usr/local/php72
    ;;

  * )
    echo "ONLY SUPPORT 5.6 +"
    exit 1
esac

# verify os

# . /etc/os-release

#
# ID=debian
# VERSION_ID="9"
#
# ID=ubuntu
# VERSION_ID="16.04"
#

# 1. download

sudo mkdir -p /usr/local/src || echo

if ! [ -d /usr/local/src/php-${PHP_VERSION} ];then

  echo -e "Download php src ...\n\n"

  cd /usr/local/src

  sudo chmod 777 /usr/local/src

  wget ${PHP_URL}/php-${PHP_VERSION}.tar.gz

  echo -e "Untar ...\n\n"

  tar -zxvf php-${PHP_VERSION}.tar.gz > /dev/null 2>&1
fi

cd /usr/local/src/php-${PHP_VERSION}

# 2. install packages

# sudo yum update

_yum(){

sudo yum info libargon2-devel > /dev/null 2>&1 || export ARGON2=false

export DEP_SOFTS="autoconf \
                   dpkg-dev \
                   \
                   \
                   make \
                   \
                   re2c \
                   gcc gcc-c++ \
                   libedit-devel \
                   zlib-devel \
                   libxml2-devel \
                   openssl-devel \
                   libsqlite3x-devel \
                   libxslt-devel \
                   libcurl-devel \
                   libpqxx-devel \
                   libmemcached-devel \
                   cyrus-sasl-devel \
                   freetype-devel \
                   libpng-devel \
                   libjpeg-devel \
                   \
                   $( test $PHP_NUM = "56" && echo "" ) \
                   $( test $PHP_NUM = "70" && echo "" ) \
                   $( test $PHP_NUM = "71" && echo "" ) \
                   $( if [ $PHP_NUM = "72" ];then \
                        echo $( if ! [ "${ARGON2}" = 'false' ];then \
                                  echo "libargon2-devel";
                                fi ); \
                        echo "libsodium-devel libzip-devel"; \
                      fi ) \
                      \
                   libyaml-devel \
                   libtidy-devel \
                   xmlrpc-c-devel \
                   bzip2 \
                   bzip2-devel \
                   libexif-devel \
                   libexif \
                   gmp \
                   gmp-devel \
                   libc-client \
                   libc-client-devel \
                   readline readline-devel \
                   "

for soft in ${DEP_SOFTS}
do
    sudo echo $soft >> ${PHP_INSTALL_LOG}
done

sudo yum update

sudo yum install -y ${DEP_SOFTS}
}

if [ "$1" = yum ];then _yum ; exit $?; fi

_yum

# 3. bug

# https://blog.csdn.net/alexdream/article/details/7408453

sudo ln -sf /usr/lib64/libc-client.so /usr/lib/libc-client.so

# 4. configure

CONFIGURE="--prefix=${PHP_ROOT} \
    --with-config-file-path=/usr/local/etc/php${PHP_NUM} \
    --with-config-file-scan-dir=/usr/local/etc/php${PHP_NUM}/conf.d \
    --disable-cgi \
    --enable-fpm \
    --with-fpm-user=nginx \
    --with-fpm-group=nginx \
    --with-curl \
    --with-gd \
    --with-gettext \
    --with-iconv-dir \
    --with-kerberos \
    --with-libedit \
    --with-openssl \
    --with-pcre-regex \
    --with-pdo-mysql \
    --with-pdo-pgsql \
    --with-xsl \
    --with-zlib \
    --with-mhash \
    --with-png-dir=/usr/lib \
    --with-jpeg-dir=/usr/lib\
    --with-freetype-dir=/usr/lib \
    --enable-ftp \
    --enable-mysqlnd \
    --enable-bcmath \
    --enable-libxml \
    --enable-inline-optimization \
    --enable-gd-jis-conv \
    --enable-mbregex \
    --enable-mbstring \
    --enable-pcntl \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \
    --enable-sysvsem \
    --enable-xml \
    --enable-zip \
    --enable-calendar \
    --enable-intl \
    \
    $( test $PHP_NUM = "56" && echo "--enable-opcache --enable-gd-native-ttf" ) \
    $( test $PHP_NUM = "70" && echo "--enable-gd-native-ttf" ) \
    $( test $PHP_NUM = "71" && echo "--enable-gd-native-ttf" ) \
    \
    $( if [ $PHP_NUM = "72" ];then \
         echo $( if ! [ "${ARGON2}" = 'false' ];then \
                   echo "--with-password-argon2";
                 fi ); \
         echo "--with-sodium --with-libzip"; \
       fi ) \
    --enable-exif \
    --with-bz2 \
    --with-tidy \
    --with-gmp \
    --with-imap \
    --with-imap-ssl \
    --with-xmlrpc \
    "

for a in ${CONFIGURE}
do
  sudo echo $a >> ${PHP_INSTALL_LOG}
done

./configure ${CONFIGURE}

# 5. make

make

# 6. make install

sudo make install

# 7. install extension

if [ -d /usr/local/etc/php${PHP_NUM} ];then
    sudo mv /usr/local/etc/php${PHP_NUM} /usr/local/etc/php${PHP_NUM}.$( date +%s ).backup
fi

sudo mkdir -p /usr/local/etc/php${PHP_NUM}/conf.d

sudo cp /usr/local/src/php-${PHP_VERSION}/php.ini-development /usr/local/etc/php${PHP_NUM}/php.ini
sudo cp /usr/local/php${PHP_NUM}/etc/php-fpm.d/www.conf.default /usr/local/php${PHP_NUM}/etc/php-fpm.d/www.conf
sudo cp /usr/local/php${PHP_NUM}/etc/php-fpm.conf.default /usr/local/php${PHP_NUM}/etc/php-fpm.conf

${PHP_ROOT}/bin/php -v

${PHP_ROOT}/bin/php -i | grep ".ini"

${PHP_ROOT}/sbin/php-fpm -v

sudo ${PHP_ROOT}/bin/pear config-set php_ini /usr/local/etc/php${PHP_NUM}/php.ini
sudo ${PHP_ROOT}/bin/pecl config-set php_ini /usr/local/etc/php${PHP_NUM}/php.ini

sudo ${PHP_ROOT}/bin/pecl update-channels

sudo ${PHP_ROOT}/bin/pear config-show >> ${PHP_INSTALL_LOG}
sudo ${PHP_ROOT}/bin/pecl config-show >> ${PHP_INSTALL_LOG}

sudo ${PHP_ROOT}/bin/php-config >> ${PHP_INSTALL_LOG} || echo > /dev/null 2>&1

PHP_EXTENSION="igbinary \
               redis \
               $( if [ $PHP_NUM = "56" ];then echo "memcached-2.2.0"; else echo "memcached"; fi ) \
               $( if [ $PHP_NUM = "56" ];then echo "xdebug-2.5.5"; else echo "xdebug"; fi ) \
               $( if [ $PHP_NUM = "56" ];then echo "yaml-1.3.1"; else echo "yaml"; fi ) \
               $( if ! [ $PHP_NUM = "56" ];then echo "swoole"; else echo ""; fi ) \
               mongodb"

for extension in ${PHP_EXTENSION}
do
  echo $extension >> ${PHP_INSTALL_LOG}
  sudo ${PHP_ROOT}/bin/pecl install $extension || echo
done

# 8. enable extension

if [ ${PHP_NUM} -ge 72 ];then

echo "zend_extension=opcache" | sudo tee /usr/local/etc/php${PHP_NUM}/conf.d/extension-opcache.ini

else

echo "zend_extension=opcache.so" | sudo tee /usr/local/etc/php${PHP_NUM}/conf.d/extension-opcache.ini

fi

echo "
[global]

pid = /var/run/php${PHP_NUM}-fpm.pid

error_log = /var/log/php${PHP_NUM}-fpm.error.log

[www]

access.log = /var/log/php${PHP_NUM}-fpm.access.log

user = nginx
group = nginx

request_slowlog_timeout = 5
slowlog = /var/log/php${PHP_NUM}-fpm.slow.log

listen 9000

;
; wsl
;
; listen = /var/run/php-fpm${PHP_NUM}.sock
;
; listen.owner = nginx
; listen.group = nginx
; listen.mode = 0660
; env[APP_ENV] = wsl

env[APP_ENV] = development
" | sudo tee ${PHP_ROOT}/etc/php-fpm.d/zz-$( . /etc/os-release ; echo $ID ).conf

cd /var/log

if ! [ -f php${PHP_NUM}-fpm.error.log ];then sudo touch php${PHP_NUM}-fpm.error.log ; fi
if ! [ -f php${PHP_NUM}-fpm.access.log ];then sudo touch php${PHP_NUM}-fpm.access.log ; fi
if ! [ -f php${PHP_NUM}-fpm.slow.log ];then sudo touch php${PHP_NUM}-fpm.slow.log; fi

sudo chmod 777 php${PHP_NUM}-*

# Change php ini

sudo sed -i 's#^extension="xdebug.so".*#zend_extension=xdebug#g' /usr/local/etc/php${PHP_NUM}/php.ini

${PHP_ROOT}/bin/php -v
