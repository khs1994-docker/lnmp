#!/usr/bin/env bash

#
# Build php in WSL(Debian Ubuntu)
#
# $ lnmp-wsl-php-builder.sh 5.6.35 [--skipbuild] [tar] [deb] [travis] [arm64] [arm32]
#

# help info

_print_help_info(){

    echo "

Build php in WSL Debian by shell script

Usage:

$ lnmp-wsl-builder-php.sh 7.2.7

$ lnmp-wsl-builder-php.sh apt

$ lnmp-wsl-builder-php.sh 7.3.0

$ lnmp-wsl-builder-php.sh 7.2.7 [--skipbuild] [tar] [deb] [enable-ext]

$ lnmp-wsl-builder-php.sh 7.2.7 arm64 tar [TODO]

$ lnmp-wsl-builder-php.sh 7.2.7 arm32 tar [TODO]

"

exit 0

}

################################################################################

PHP_TIMEZONE=PRC

PHP_URL=http://cn2.php.net/distributions

host=x86_64-linux-gnu

for command in "$@"
do
test $command = 'travis' && PHP_URL=https://secure.php.net/distributions
test $command = 'arm64' && host=aarch64-linux-gnu
test $command = 'arm32' && host=arm-linux-gnueabihf
done

PHP_INSTALL_LOG=/tmp/php-builder/$(date +%s).install.log

export COMPOSER_VERSION=1.6.5

export COMPOSER_ALLOW_SUPERUSER=1

export COMPOSER_HOME=/tmp

export TZ=Asia/Shanghai

export CC=clang CXX=clang

# export CC=gcc CXX=g++

test $host = 'aarch64-linux-gnu' && \
              export CC=aarch64-linux-gnu-gcc \
                     CXX=aarch64-linux-gnu-g++ \
                     armMake="ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-"

test $host = 'arm-linux-gnueabihf' && \
              export CC=arm-linux-gnueabihf-gcc \
                     CXX=arm-linux-gnueabihf-g++ \
                     armMake="ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-"

################################################################################

#
# https://github.com/docker-library/php/issues/272
#

PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
PHP_CPPFLAGS="$PHP_CFLAGS"
PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

################################################################################

_get_phpnum(){

case "$1" in
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

  7.3.* )
     sudo apt install bison git -y
     export PHP_NUM=73
    ;;

  * )
    echo "ONLY SUPPORT 5.6 +"
    exit 1
esac
}

################################################################################

# download php src

_download_src(){

    sudo mkdir -p /usr/local/src || echo

    if ! [ -d /usr/local/src/php-${PHP_VERSION} ];then

        echo -e "Download php src ...\n\n"

        cd /usr/local/src ; sudo chmod 777 /usr/local/src

        if [ $PHP_NUM = 73 ];then

          git clone --depth=1 https://github.com/php/php-src.git /usr/local/src/php-7.3.0 || \
            ( git -C /usr/local/src/php-7.3.0 fetch --depth=1 origin master ; \
              git -C /usr/local/src/php-7.3.0 fetch reset --hard origin/master ;
            )

          return
        fi

        wget ${PHP_URL}/php-${PHP_VERSION}.tar.gz > /dev/null

        echo -e "Untar ...\n\n"

        tar -zxvf php-${PHP_VERSION}.tar.gz > /dev/null 2>&1
    fi
}

################################################################################

# install packages

_build_arm_php_build_dep(){
################################################################################

  DEP_PREFIX=/opt/${host}

  ZLIB_VERSION=1.2.11
  LIBXML2_VERSION=2.9.8

################################################################################

_buildlib(){
  if [ -f /opt/${host}/$LIB_NAME ];then return 0 ; fi

  cd /tmp ; test ! -d $TAR_FILE && ( wget $URL ; tar -zxvf $TAR )

  cd $TAR_FILE && ./configure $CONFIGURES && make && sudo make install
}

################################################################################

LIB_NAME=
URL=
TAR=
TAR_FILE=
CONFIGURES="--prefix=${DEP_PREFIX}/zlib"
# _buildlib

################################################################################

LIB_NAME=zlib/lib/libz.so.${ZLIB_VERSION}
URL=http://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz
TAR=zlib-${ZLIB_VERSION}.tar.gz
TAR_FILE=zlib-${ZLIB_VERSION}
CONFIGURES="--prefix=${DEP_PREFIX}/zlib"
_buildlib

################################################################################

command -v python-config || pip install python-config

LIB_NAME=libxm2/lib/libxml2.so.${LIBXML2_VERSION}
URL=ftp://xmlsoft.org/libxml2/libxml2-${LIBXML2_VERSION}.tar.gz
TAR=libxml2-${LIBXML2_VERSION}.tar.gz
TAR_FILE=libxml2-${LIBXML2_VERSION}
CONFIGURES="--prefix=${DEP_PREFIX}/libxm2 \
                        --host=${host} \
                        --with-zlib=${DEP_PREFIX}/zlib \
                        --with-python=/tmp/$TAR_FILE/python"
_buildlib

################################################################################

}

_install_php_run_dep(){

    test $host != 'x86_64-linux-gnu' && _build_arm_php_build_dep ; return 0
    set +e
    export PHP_RUN_DEP="libedit2 \
zlib1g \
libxml2 \
openssl \
libsqlite3-0 \
libxslt1.1 \
libpq5 \
libmemcached11 \
libmemcachedutil2 \
libsasl2-2 \
libfreetype6 \
libpng16-16 \
$( sudo apt install -y libjpeg62-turbo > /dev/null 2>&1 && echo libjpeg62-turbo ) \
$( sudo apt install -y libjpeg-turbo8 > /dev/null 2>&1 && echo libjpeg-turbo8 ) \
$( if [ $PHP_NUM -ge "72" ];then \
echo $( if ! [ "${ARGON2}" = 'false' ];then \
echo "libargon2-0";
          fi ); \
echo "libsodium18 libzip4"; \
   fi ) \
libyaml-0-2 \
$( sudo apt install -y libtidy-0.99-0 > /dev/null 2>&1 && echo libtidy-0.99-0 ) \
$( sudo apt install -y libtidy5 > /dev/null 2>&1 && echo libtidy5 ) \
libxmlrpc-epi0 \
libbz2-1.0 \
libexif12 \
libgmp10 \
libc-client2007e \
libkrb5-3 \
libxpm4 \
$( sudo apt install -y libwebp6 > /dev/null 2>&1 && echo libwebp6 ) \
$( sudo apt install -y libwebp5 > /dev/null 2>&1 && echo libwebp5 ) \
libenchant1c2a \
libssl1.1 \
libicu57 \
libldap-2.4-2"
    set -e
    sudo apt install -y $PHP_RUN_DEP > /dev/null
}

################################################################################

_install_php_build_dep(){
    set +e
    export DEP_SOFTS="autoconf \
                   curl \
                   lsb-release \
                   dpkg-dev \
                   file \
                   $( test ${CC:-gcc} = 'gcc'  && echo "gcc g++ libc6-dev" ) \
                   $( test $CC = 'clang'       && echo "clang" ) \
                   $( test $host = 'aarch64-linux-gnu'    && echo "gcc-aarch64-linux-gnu g++-aarch64-linux-gnu" ) \
                   $( test $host = 'arm-linux-gnueabihf'  && echo "gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf" ) \
                   make \
                   pkg-config \
                   re2c \
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
                   $( sudo apt install -y libjpeg62-turbo-dev > /dev/null 2>&1 && echo libjpeg62-turbo-dev ) \
                   $( sudo apt install -y libjpeg-turbo8-dev > /dev/null 2>&1 && echo libjpeg-turbo8-dev ) \
                   \
                   $( test $PHP_NUM = "56" && echo "" ) \
                   $( test $PHP_NUM = "70" && echo "" ) \
                   $( test $PHP_NUM = "71" && echo "" ) \
                   $( if [ $PHP_NUM -ge "72" ];then \
                        echo $( if ! [ "${ARGON2}" = 'false' ];then \
                                  echo "libargon2-0-dev"; \
                                fi ); \
                        echo "libsodium-dev libzip-dev"; \
                      fi ) \
                      \
                   libyaml-dev \
                   libtidy-dev \
                   libxmlrpc-epi-dev \
                   libbz2-dev \
                   libexif-dev \
                   libgmp-dev \
                   libc-client2007e-dev \
                   libkrb5-dev \
                   \
                   libxpm-dev \
                   libwebp-dev \
                   libenchant-dev \
                   libldap2-dev \
                   libpspell-dev \
                   libicu-dev \
                   "
    set -e
    for soft in ${DEP_SOFTS} ; do echo $soft | tee -a ${PHP_INSTALL_LOG} ; done

    sudo apt install -y --no-install-recommends ${DEP_SOFTS} > /dev/null
}

################################################################################

_test(){
    ${PHP_PREFIX}/bin/php -v

    sudo ln -sf ${PHP_PREFIX}/bin/php /usr/local/sbin/php

    ${PHP_PREFIX}/bin/composer --ansi --version --no-interaction || echo ; sudo rm -rf /usr/local/sbin/php

    ${PHP_PREFIX}/bin/php -i | grep .ini

    ${PHP_PREFIX}/sbin/php-fpm -v

    set +x
    for ext in `ls /usr/local/src/php-${PHP_VERSION}/ext`; \
    do echo '*' $( ${PHP_PREFIX}/bin/php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ); done
    set -x
}


################################################################################

_builder(){

# fix bug

   export gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
   debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"

_fix_bug(){
#
# https://bugs.php.net/bug.php?id=74125
#

    if [ ! -d /usr/include/curl ]; then
    sudo ln -sTf "/usr/include/$debMultiarch/curl" /usr/local/include/curl
    fi

#
# https://stackoverflow.com/questions/34272444/compiling-php7-error
#

    sudo ln -sf /usr/lib/libc-client.so.2007e.0 /usr/lib/$debMultiarch/libc-client.a

#
# debian 9 php56 configure: error: Unable to locate gmp.h
#

    sudo ln -sf /usr/include/$debMultiarch/gmp.h /usr/include/gmp.h

#
# https://stackoverflow.com/questions/43617752/docker-php-and-freetds-cannot-find-freetds-in-know-installation-directories
#

    # sudo ln -sf /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/

#
# configure: error: Cannot find ldap libraries in /usr/lib.
#
# @link https://blog.csdn.net/ei__nino/article/details/8598490

    sudo cp -frp /usr/lib/$debMultiarch/libldap* /usr/lib/
}

test $host = 'x86_64-linux-gnu'  && _fix_bug

################################################################################

# configure
    set +e
    CONFIGURE="--prefix=${PHP_PREFIX} \
      --sysconfdir=${PHP_INI_DIR} \
      \
      --build="$gnuArch" \
      --host=${host:-x86_64-linux-gnu} \
      \
      --with-config-file-path=${PHP_INI_DIR} \
      --with-config-file-scan-dir=${PHP_INI_DIR}/conf.d \
      --disable-cgi \
      --enable-fpm \
      --with-fpm-user=nginx \
      --with-fpm-group=nginx \
      \
      --with-curl \
      --with-gettext \
      --with-kerberos \
      --with-libedit \
      --with-openssl \
          --with-system-ciphers \
      --with-pcre-regex \
      --with-pdo-mysql \
      --with-pdo-pgsql=shared \
      --with-xsl=shared \
      --with-zlib \
      --with-mhash \
      --with-gd \
          --with-freetype-dir=/usr/lib \
          --disable-gd-jis-conv \
          --with-jpeg-dir=/usr/lib \
          --with-png-dir=/usr/lib \
          --with-xpm-dir=/usr/lib \
      --enable-ftp \
      --enable-mysqlnd \
      --enable-bcmath \
      --enable-libxml \
      --enable-inline-optimization \
      --enable-mbregex \
      --enable-mbstring \
      --enable-pcntl=shared \
      --enable-shmop=shared \
      --enable-soap=shared \
      --enable-sockets=shared \
      --enable-sysvmsg=shared \
      --enable-sysvsem=shared \
      --enable-sysvshm=shared \
      --enable-xml \
      --enable-zip \
      --enable-calendar=shared \
      --enable-intl=shared \
      --enable-embed=shared \
      --enable-option-checking=fatal \
      --with-mysqli=shared \
      --with-pgsql=shared \
    \
    $( test $PHP_NUM = "56" && echo "--enable-opcache --enable-gd-native-ttf" ) \
    $( test $PHP_NUM = "70" && echo "--enable-gd-native-ttf --with-webp-dir=/usr/lib" ) \
    $( test $PHP_NUM = "71" && echo "--enable-gd-native-ttf --with-webp-dir=/usr/lib" ) \
    \
    $( if [ $PHP_NUM -ge "72" ];then \
         echo $( if ! [ "${ARGON2}" = 'false' ];then \
                   echo "--with-password-argon2"; \
                 fi ); \
         echo "--with-sodium --with-libzip --with-webp-dir=/usr/lib --with-pcre-jit"; \
       fi ) \
      --enable-exif \
      --with-bz2 \
      --with-tidy \
      --with-gmp \
      --with-imap=shared \
          --with-imap-ssl \
      --with-xmlrpc \
      \
      --with-pic \
      --with-enchant=shared \
      --enable-fileinfo \
      --with-ldap=shared \
          --with-ldap-sasl \
      --enable-phar \
      --enable-posix=shared \
      --with-pspell=shared \
      --enable-shmop=shared \
      --enable-wddx=shared \
      $( test "$host" != 'x86_64-linux-gnu' && echo "--with-libxml-dir=/opt/${host}/libxml2 \
                                                     --with-zlib-dir=/opt/${host}/zlib" ) \
      "
    set -e
    for a in ${CONFIGURE}; do echo $a | tee -a ${PHP_INSTALL_LOG}; done

    cd /usr/local/src/php-${PHP_VERSION}

    export CFLAGS="$PHP_CFLAGS"
    export CPPFLAGS="$PHP_CPPFLAGS"
    export LDFLAGS="$PHP_LDFLAGS"

    if ! [ -f configure ];then
      ./buildconf --force
    fi

    ./configure ${CONFIGURE}

# make

    make -j "$(nproc)"

# make install

    sudo rm -rf ${PHP_PREFIX} || echo

    if [ -d ${PHP_INI_DIR} ];then sudo mv ${PHP_INI_DIR} ${PHP_INI_DIR}.$( date +%s ).backup; fi

    sudo make install

    sudo mkdir -p ${PHP_INI_DIR}/conf.d

    sudo cp /usr/local/src/php-${PHP_VERSION}/php.ini-development ${PHP_INI_DIR}/php.ini
    sudo cp /usr/local/src/php-${PHP_VERSION}/php.ini-development ${PHP_INI_DIR}/php.ini-development
    sudo cp /usr/local/src/php-${PHP_VERSION}/php.ini-production  ${PHP_INI_DIR}/php.ini-production

# php5 not have php-fpm.d

    cd ${PHP_INI_DIR}

    if ! [ -d php-fpm.d ]; then
    # php5
        sudo mkdir php-fpm.d
        sudo cp php-fpm.conf.default php-fpm.d/www.conf

    { \
        echo '[global]'; \
        echo "include=${PHP_INI_DIR}/php-fpm.d/*.conf"; \
    } | sudo tee php-fpm.conf

    else
        sudo cp php-fpm.d/www.conf.default php-fpm.d/www.conf
        sudo cp php-fpm.conf.default php-fpm.conf
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

clear_env = no

catch_workers_output = yes

; listen = 9000
; env[APP_ENV] = development

;
; wsl
;

listen = /var/run/php${PHP_NUM}-fpm.sock
listen.owner = nginx
listen.group = nginx
listen.mode = 0660
env[APP_ENV] = wsl

" | sudo tee ${PHP_INI_DIR}/php-fpm.d/zz-${ID}.conf

}

_install_pecl_ext(){

    #
    # https://github.com/docker-library/php/issues/443
    #


    sudo ${PHP_PREFIX}/bin/pecl update-channels

    PHP_EXTENSION="igbinary \
               redis \
               $( if [ $PHP_NUM = "56" ];then echo "memcached-2.2.0"; else echo "memcached"; fi ) \
               $( if [ $PHP_NUM = "56" ];then echo "xdebug-2.5.5"; else echo "xdebug"; fi ) \
               $( if [ $PHP_NUM = "56" ];then echo "yaml-1.3.1"; else echo "yaml"; fi ) \
               $( if ! [ $PHP_NUM = "56" ];then echo "swoole"; else echo ""; fi ) \
               mongodb"

    for extension in ${PHP_EXTENSION}
    do
        echo $extension | tee -a ${PHP_INSTALL_LOG}
        sudo ${PHP_PREFIX}/bin/pecl install $extension || echo
    done
}

_php_ext_enable(){

echo "date.timezone=${PHP_TIMEZONE:-PRC}" | sudo tee ${PHP_INI_DIR}/conf.d/date_timezone.ini
echo "error_log=/var/log/php${PHP_NUM}.error.log" | sudo tee ${PHP_INI_DIR}/conf.d/error_log.ini
echo "session.save_path = \"/tmp\"" | sudo tee ${PHP_INI_DIR}/conf.d/session.ini
set +e
exts=" pdo_pgsql \
                      xsl \
                      pcntl \
                      shmop \
                      soap \
                      sockets \
                      sysvmsg \
                      sysvsem \
                      sysvshm \
                      calendar \
                      intl \
                      imap \
                      enchant \
                      ldap \
                      posix \
                      pspell \
                      wddx \
                      \
                      mongodb \
                      igbinary \
                      redis \
                      memcached \
                      xdebug \
                      $( test $PHP_NUM != '56' && echo 'swoole' ) \
                      yaml \
                      opcache \
                      mysqli \
                      pgsql "
set -e
for ext in $exts
do
  wsl-php-ext-enable.sh $ext || echo "$ext install error"
done

# config opcache

# echo 'opcache.enable_cli=1' | sudo tee -a ${PHP_INI_DIR}/conf.d/wsl-php-ext-opcache.ini
echo 'opcache.file_cache=/tmp' | sudo tee -a ${PHP_INI_DIR}/conf.d/wsl-php-ext-opcache.ini
}

_create_log_file(){

cd /var/log

if ! [ -f php${PHP_NUM}-fpm.error.log ];then sudo touch php${PHP_NUM}-fpm.error.log ; fi
if ! [ -f php${PHP_NUM}-fpm.access.log ];then sudo touch php${PHP_NUM}-fpm.access.log ; fi
if ! [ -f php${PHP_NUM}-fpm.slow.log ];then sudo touch php${PHP_NUM}-fpm.slow.log; fi

sudo chmod 777 php${PHP_NUM}-*
}

_composer(){
   curl -sfL -o /tmp/installer.php \
       https://raw.githubusercontent.com/composer/getcomposer.org/b107d959a5924af895807021fcef4ffec5a76aa9/web/installer

   ${PHP_PREFIX}/bin/php -r " \
        \$signature = '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061'; \
        \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
        if (!hash_equals(\$signature, \$hash)) { \
            unlink('/tmp/installer.php'); \
            echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
            exit(1); \
        }" \
&& sudo ${PHP_PREFIX}/bin/php /tmp/installer.php --no-ansi --install-dir=${PHP_PREFIX}/bin --filename=composer --version=${COMPOSER_VERSION}
}

################################################################################

_write_version_to_file(){
echo "\`\`\`bash" | sudo tee -a ${PHP_PREFIX}/README.md

${PHP_PREFIX}/bin/php -v | sudo tee -a ${PHP_PREFIX}/README.md

echo "\`\`\`" | sudo tee -a ${PHP_PREFIX}/README.md

echo "\`\`\`bash" | sudo tee -a ${PHP_PREFIX}/README.md

${PHP_PREFIX}/bin/php -i | grep .ini | sudo tee -a ${PHP_PREFIX}/README.md

echo "\`\`\`" | sudo tee -a ${PHP_PREFIX}/README.md

echo "\`\`\`bash" | sudo tee -a ${PHP_PREFIX}/README.md

${PHP_PREFIX}/sbin/php-fpm -v | sudo tee -a ${PHP_PREFIX}/README.md

echo "\`\`\`" | sudo tee -a ${PHP_PREFIX}/README.md

echo "\`\`\`bash" | sudo tee -a ${PHP_PREFIX}/README.md

cat ${PHP_INSTALL_LOG} | sudo tee -a ${PHP_PREFIX}/README.md

echo "\`\`\`" | sudo tee -a ${PHP_PREFIX}/README.md

set +x
for ext in `ls /usr/local/src/php-${PHP_VERSION}/ext`; \
do echo '*' $( ${PHP_PREFIX}/bin/php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ) | sudo tee -a ${PHP_PREFIX}/README.md ; done
set -x
cat ${PHP_PREFIX}/README.md

}

################################################################################

_tar(){
  cd /usr/local

  test $host = 'aarch64-linux-gnu' && cd arm64

  sudo tar -zcvf php${PHP_NUM}.tar.gz php${PHP_NUM}

  cd etc ; sudo tar -zcvf php${PHP_NUM}-etc.tar.gz php${PHP_NUM}

  sudo mv ${PHP_PREFIX}.tar.gz /

  sudo mv ${PHP_INI_DIR}-etc.tar.gz /
}

################################################################################

_deb(){

cd /tmp; sudo rm -rf khs1994-wsl-php-${PHP_VERSION} || echo ; mkdir -p khs1994-wsl-php-${PHP_VERSION}/DEBIAN ; cd khs1994-wsl-php-${PHP_VERSION}

################################################################################

echo "Package: khs1994-wsl-php
Version: ${PHP_VERSION}
Prioritt: optional
Section: php
Architecture: amd64
Maintainer: khs1994 <khs1994@khs1994.com>
Bugs: https://github.com/khs1994-docker/lnmp/issues
Depends: $( echo ${PHP_RUN_DEP} | sed "s# #, #g" )
Homepage: https://lnmp.khs1994.com
Description: server-side, HTML-embedded scripting language (default)
 PHP (recursive acronym for PHP: Hypertext Preprocessor) is a widely-used
 open source general-purpose scripting language that is especially suited
 for web development and can be embedded into HTML.

" > DEBIAN/control

echo "#!/bin/bash

# log

cd /var/log

if ! [ -f php${PHP_NUM}.error.log ];then sudo touch php${PHP_NUM}.error.log ; fi
if ! [ -f php${PHP_NUM}-fpm.error.log ];then sudo touch php${PHP_NUM}-fpm.error.log ; fi
if ! [ -f php${PHP_NUM}-fpm.access.log ];then sudo touch php${PHP_NUM}-fpm.access.log ; fi
if ! [ -f php${PHP_NUM}-fpm.slow.log ];then sudo touch php${PHP_NUM}-fpm.slow.log; fi

sudo chmod 777 php${PHP_NUM}*

# bin sbin

for file in \$( ls ${PHP_PREFIX}/bin ); do sudo ln -sf ${PHP_PREFIX}/bin/\$file /usr/local/bin/ ; done

sudo ln -sf ${PHP_PREFIX}/sbin/php-fpm /usr/local/sbin/
" > DEBIAN/postinst

echo "#!/bin/bash
echo
echo \"Meet issue? Please see https://github.com/khs1994-docker/lnmp/issues \"
echo
" > DEBIAN/postrm

echo "#!/bin/bash

if [ -d ${PHP_INI_DIR} ];then
  sudo mv ${PHP_INI_DIR} ${PHP_INI_DIR}.\$( date +%s ).backup
fi

echo -e \"

----------------------------------------------------------------------

Thanks for using khs1994-wsl-php !

Please find the official documentation for khs1994-wsl-php here:
* https://github.com/khs1994-docker/lnmp/tree/master/wsl

Meet issue? please see:
* https://github.com/khs1994-docker/lnmp/issues

----------------------------------------------------------------------

\"
" > DEBIAN/preinst

################################################################################

chmod -R 755 DEBIAN ; mkdir -p usr/local/etc

sudo cp -a ${PHP_PREFIX} usr/local/php${PHP_NUM} ; sudo cp -a ${PHP_INI_DIR} usr/local/etc/

cd ..

DEB_NAME=khs1994-wsl-php_${PHP_VERSION}-${ID}-$( lsb_release -cs )_amd64.deb

sudo dpkg-deb -b khs1994-wsl-php-${PHP_VERSION} $DEB_NAME

sudo cp -a /tmp/${DEB_NAME} /

echo "$ sudo dpkg -i ${DEB_NAME}"

sudo rm -rf $PHP_PREFIX ; sudo rm -rf $PHP_INI_DIR

sudo dpkg -i /${DEB_NAME}

# test

test $host = 'x86_64-linux-gnu'  && _test

}

################################################################################

if [ -z "$1" ];then _print_help_info ; else PHP_VERSION=$1 ; fi

set -ex

sudo apt update

command -v wget || sudo apt install wget -y

mkdir -p /tmp/php-builder || echo

test "$PHP_VERSION" = 'apt' && PHP_VERSION=7.2.7

_get_phpnum $PHP_VERSION

export PHP_PREFIX=/usr/local/php${PHP_NUM}

export PHP_INI_DIR=/usr/local/etc/php${PHP_NUM}

test $host = 'aarch64-linux-gnu' && \
              export PHP_PREFIX=/usr/local/arm64/php${PHP_NUM} \
                     PHP_INI_DIR=/usr/local/arm64/etc/php${PHP_NUM}

test $host = 'arm-linux-gnueabihf' && \
              export PHP_PREFIX=/usr/local/arm32/php${PHP_NUM} \
                     PHP_INI_DIR=/usr/local/arm32/etc/php${PHP_NUM}

# verify os

. /etc/os-release

#
# ID=debian
# VERSION_ID="9"
#
# ID=ubuntu
# VERSION_ID="16.04"
#

# debian9 notsupport php56

if [ "$ID" = 'debian' ] && [ "$VERSION_ID" = "9" ] && [ $PHP_NUM = "56" ];then \
  echo "debian9 notsupport php56" ; exit 1 ; fi

sudo apt install -y libargon2-0-dev > /dev/null 2>&1 || export ARGON2=false

echo $2

if [ "$2" = 'enable-ext' ];then
  ( _install_pecl_ext ; _php_ext_enable ; _create_log_file ; \
  _composer ; ( test $host = 'x86_64-linux-gnu'  && \
  _test \
  ${PHP_PREFIX}/bin/php-config | sudo tee -a ${PHP_INSTALL_LOG} || echo > /dev/null 2>&1 \
  ) ; _write_version_to_file )

  exit
fi

_install_php_run_dep

if [ "$1" = 'apt' ];then _install_php_build_dep ; exit $? ; fi

_install_php_build_dep

for command in "$@"
do
  test $command = '--skipbuild' && export SKIP_BUILD=1
done

test "${SKIP_BUILD}" != 1 &&  \
    ( _download_src ; _builder ; _install_pecl_ext ; _php_ext_enable ; _create_log_file ; \
    _composer ; ( test $host = 'x86_64-linux-gnu'  && \
    _test \
    ${PHP_PREFIX}/bin/php-config | sudo tee -a ${PHP_INSTALL_LOG} || echo > /dev/null 2>&1 \
    ) ; _write_version_to_file )

for command in "$@"
do
  test $command = 'tar' && _tar
  test $command = 'deb' && _deb
done

ls -la /*.tar.gz

ls -la /*.deb
