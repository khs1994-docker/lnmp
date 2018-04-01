#！/bin/bash

set -ex

#
# Build php in WSL(Debian Ubuntu)
#

PHP_TIMEZONE=PRC

command -v wget || ( sudo apt update && sudo apt install wget -y)

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

if [ $PHP_VERSION = 'apt' ];then PHP_VERSION=7.2.4; fi

case ${PHP_VERSION} in
  5.6.* )
    export PHP_NUM=56
    ;;

  7.0.* )
    export PHP_NUM=70
    ;;

  7.1.* )
    export PHP_NUM=71
    ;;

  7.2.* )
    export PHP_NUM=72
    ;;

  * )
    echo "ONLY SUPPORT 5.6 +"
    exit 1
esac

export PHP_ROOT=/usr/local/php${PHP_NUM}

sudo rm -rf ${PHP_ROOT} || echo

export PHP_INI_DIR=/usr/local/etc/php${PHP_NUM}

# verify os

. /etc/os-release

#
# ID=debian
# VERSION_ID="9"
#
# ID=ubuntu
# VERSION_ID="16.04"
#

OS="$ID"

if [ "$OS" = 'debian' ] && [ "$VERSION_ID" = "9" ] && [ $PHP_NUM = "56" ];then
  exit 1;
fi

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

# sudo apt update

_apt(){

sudo apt show libargon2-0-dev > /dev/null 2>&1 || export ARGON2=false

export DEP_SOFTS="autoconf \
                   dpkg-dev \
                   file \
                   libc6-dev \
                   make \
                   pkg-config \
                   re2c \
                   gcc g++ \
                   libedit-dev \
                   zlib1g-dev \
                   libxml2-dev \
                   libssl-dev \
                   libsqlite3-dev \
                   libxslt1-dev \
                   libcurl4-openssl-dev \
                   libpq-dev \
                   libmemcached-dev \
                   libsasl2-dev \
                   libfreetype6-dev \
                   libpng-dev \
                   libjpeg-dev \
                   \
                   $( test $PHP_NUM = "56" && echo "" ) \
                   $( test $PHP_NUM = "70" && echo "" ) \
                   $( test $PHP_NUM = "71" && echo "" ) \
                   $( if [ $PHP_NUM = "72" ];then \
                        echo $( if ! [ "${ARGON2}" = 'false' ];then \
                                  echo "libargon2-0-dev";
                                fi ); \
                        echo "libsodium-dev libzip-dev"; \
                      fi ) \
                      \
                   libyaml-dev \
                   libtidy-dev \
                   libxmlrpc-epi0 \
                   libxmlrpc-epi-dev \
                   libbz2-1.0 \
                   libbz2-dev \
                   libexif12 \
                   libexif-dev \
                   libgmp3-dev \
                   libc-client2007e \
                   libc-client2007e-dev \
                   libkrb5-dev \
                   "

for soft in ${DEP_SOFTS}
do
    sudo echo $soft >> ${PHP_INSTALL_LOG}
done

sudo apt update

sudo apt install -y --no-install-recommends ${DEP_SOFTS}
}

if [ "$1" = apt ];then _apt ; exit $?; fi

_apt

# 3. bug

debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"
# https://bugs.php.net/bug.php?id=74125
if [ ! -d /usr/include/curl ]; then
    sudo ln -sTf "/usr/include/$debMultiarch/curl" /usr/local/include/curl
fi

# https://stackoverflow.com/questions/34272444/compiling-php7-error
sudo ln -sf /usr/lib/libc-client.so.2007e.0 /usr/lib/x86_64-linux-gnu/libc-client.a

#
# debian 9 php56 configure: error: Unable to locate gmp.h
#

sudo ln -sf /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h

# 4. configure

CONFIGURE="--prefix=${PHP_ROOT} \
    --with-config-file-path=${PHP_INI_DIR} \
    --with-config-file-scan-dir=${PHP_INI_DIR}/conf.d \
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

make -j "$(nproc)"

# 6. make install

sudo make install

# 7. install extension

if [ -d ${PHP_INI_DIR} ];then
    sudo mv ${PHP_INI_DIR} ${PHP_INI_DIR}.$( date +%s ).backup
fi

sudo mkdir -p ${PHP_INI_DIR}/conf.d

sudo cp /usr/local/src/php-${PHP_VERSION}/php.ini-development ${PHP_INI_DIR}/php.ini

# php5 not have php-fpm.d

cd /usr/local/php${PHP_NUM}/etc/

if ! [ -d php-fpm.d ]; then
  # php5
  sudo mkdir php-fpm.d
  sudo cp php-fpm.conf.default php-fpm.d/www.conf

  { \
    echo '[global]'; \
    echo "include=${PHP_ROOT}/etc/php-fpm.d/*.conf"; \
  } | sudo tee php-fpm.conf

else
  sudo cp php-fpm.d/www.conf.default php-fpm.d/www.conf
  sudo cp php-fpm.conf.default php-fpm.conf
fi

${PHP_ROOT}/bin/php -v

${PHP_ROOT}/bin/php -i | grep ".ini"

${PHP_ROOT}/sbin/php-fpm -v

sudo ${PHP_ROOT}/bin/pear config-set php_ini ${PHP_INI_DIR}/php.ini
sudo ${PHP_ROOT}/bin/pecl config-set php_ini ${PHP_INI_DIR}/php.ini

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

echo "zend_extension=opcache" | sudo tee ${PHP_INI_DIR}/conf.d/extension-opcache.ini
echo "date.timezone=${PHP_TIMEZONE:-PRC}" | sudo tee ${PHP_INI_DIR}/conf.d/date_timezone.ini

else

echo "zend_extension=opcache.so" | sudo tee ${PHP_INI_DIR}/conf.d/extension-opcache.ini
echo "date.timezone=${PHP_TIMEZONE:-PRC}" | sudo tee ${PHP_INI_DIR}/conf.d/date_timezone.ini

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

sudo sed -i 's#^extension="xdebug.so".*#zend_extension=xdebug#g' ${PHP_INI_DIR}/php.ini

${PHP_ROOT}/bin/php -v

${PHP_ROOT}/bin/php -i | grep .ini

${PHP_ROOT}/sbin/php-fpm -v

set +x

for ext in `ls /usr/local/src/php-${PHP_VERSION}/ext`; \
do echo '*' $( ${PHP_ROOT}/bin/php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ); done

################################################################################

echo "\`\`\`bash" | sudo tee -a ${PHP_ROOT}/README.md

${PHP_ROOT}/bin/php -v | sudo tee -a ${PHP_ROOT}/README.md

echo "\`\`\`" | sudo tee -a ${PHP_ROOT}/README.md

echo "\`\`\`bash" | sudo tee -a ${PHP_ROOT}/README.md

${PHP_ROOT}/bin/php -i | grep .ini | sudo tee -a ${PHP_ROOT}/README.md

echo "\`\`\`" | sudo tee -a ${PHP_ROOT}/README.md

echo "\`\`\`bash" | sudo tee -a ${PHP_ROOT}/README.md

${PHP_ROOT}/sbin/php-fpm -v | sudo tee -a ${PHP_ROOT}/README.md

echo "\`\`\`" | sudo tee -a ${PHP_ROOT}/README.md

echo "\`\`\`bash" | sudo tee -a ${PHP_ROOT}/README.md

cat ${PHP_INSTALL_LOG} | sudo tee -a ${PHP_ROOT}/README.md

echo "\`\`\`" | sudo tee -a ${PHP_ROOT}/README.md

for ext in `ls /usr/local/src/php-${PHP_VERSION}/ext`; \
do echo '*' $( ${PHP_ROOT}/bin/php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ) | sudo tee -a ${PHP_ROOT}/README.md ; done

cat ${PHP_ROOT}/README.md

set -x

if [ "$2" = 'tar' ];then
  cd /usr/local

  sudo tar -zcvf php${PHP_NUM}.tar.gz php${PHP_NUM}

  cd etc

  sudo tar -zcvf php${PHP_NUM}-etc.tar.gz php${PHP_NUM}

sudo mv /usr/local/php${PHP_NUM}.tar.gz /

sudo mv /usr/local/etc/php${PHP_NUM}-etc.tar.gz /

fi
