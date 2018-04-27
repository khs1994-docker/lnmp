#!/bin/bash

#
# Build php in WSL(RHEL)
#
# $ lnmp-wsl-php-builder.rhel.sh 5.6.35 [--skipbuild] [tar] [rpm] [travis]
#

_print_help_info(){

    echo "

Build php in WSL RHEL by shell script

Usage:

$ lnmp-wsl-builder-php-rhel.sh 7.2.5

$ lnmp-wsl-builder-php-rhel.sh yum

$ lnmp-wsl-builder-php-rhel.sh 5.6.35 [--skipbuild] [tar] [rpm]

"

exit 0

}

################################################################################

PHP_TIMEZONE=PRC

PHP_URL=http://cn2.php.net/distributions

for command in "$@"
do
test $command = 'travis' && PHP_URL=https://secure.php.net/distributions
done

PHP_INSTALL_LOG=/tmp/php-builder/$(date +%s).install.log

export COMPOSER_VERSION=1.6.3

export COMPOSER_ALLOW_SUPERUSER=1

export COMPOSER_HOME=/tmp

export TZ=Asia/Shanghai

# export CC=clang CXX=clang

# export CC=gcc CXX=g++

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

  * )
    echo "ONLY SUPPORT 5.6 +"
    exit 1
esac
}

################################################################################

_download_src(){

    sudo mkdir -p /usr/local/src || echo

    if ! [ -d /usr/local/src/php-${PHP_VERSION} ];then

      echo -e "Download php src ...\n\n"

      cd /usr/local/src ; sudo chmod 777 /usr/local/src

      wget ${PHP_URL}/php-${PHP_VERSION}.tar.gz >/dev/null

      echo -e "Untar ...\n\n"

      tar -zxvf php-${PHP_VERSION}.tar.gz > /dev/null 2>&1
    fi
}

################################################################################

# 2. install packages

_install_php_run_dep(){

    cd /tmp ; sudo wget -N http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

    sudo rpm -Uvh epel-release*rpm

_libzip(){

# libzip php7.2
#
# checking for libzip... configure: error: system libzip must be upgraded to version >= 0.11
#

    cd /tmp

    sudo wget -N http://packages.psychotic.ninja/7/plus/x86_64/RPMS/libzip-devel-0.11.2-6.el${VERSION_ID}.psychotic.x86_64.rpm

    sudo wget -N http://packages.psychotic.ninja/7/plus/x86_64/RPMS/libzip-0.11.2-6.el${VERSION_ID}.psychotic.x86_64.rpm

    sudo rpm -Uvh libzip*rpm ; cd -
}

    test ${PHP_NUM} = '72' && _libzip

    export PHP_DEP="libedit \
zlib \
libxml2 \
openssl \
libsqlite3x \
libxslt \
libcurl \
libpqxx \
libmemcached \
cyrus-sasl \
freetype \
libpng \
libjpeg \
                $( if [ $PHP_NUM = "72" ];then \
echo $( if ! [ "${ARGON2}" = 'false' ];then \
echo "libargon2";
                             fi ); \
echo "libsodium"; \
                   fi ) \
libyaml \
libtidy \
xmlrpc-c \
bzip2 \
libexif \
gmp \
libc-client \
readline \
libicu \
libXpm \
libwebp \
enchant \
openldap \
aspell"


sudo yum install -y ${PHP_DEP} rpm-build > /dev/null
}

_install_php_build_dep(){

     export DEP_SOFTS="autoconf \
                   \
                   \
                   make \
                   \
                   re2c \
                   $( test ${CC:-gcc} = 'gcc'  && echo "gcc gcc-c++ libgcc" ) \
                   $( test $CC = 'clang'       && echo "clang" ) \
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
                                  echo "libargon2-devel"; \
                                fi ); \
                        echo "libsodium-devel"; \
                      fi ) \
                      \
                   libyaml-devel \
                   libtidy-devel \
                   xmlrpc-c-devel \
                   bzip2-devel \
                   libexif-devel \
                   gmp-devel \
                   libc-client-devel \
                   readline-devel \
                   libicu-devel \
                   libXpm-devel \
                   \
                   libwebp-devel \
                   enchant-devel \
                   openldap-devel \
                   aspell-devel \
                   "

for soft in ${DEP_SOFTS}
do
    echo $soft >> ${PHP_INSTALL_LOG}
done

sudo yum install -y ${DEP_SOFTS} > /dev/null
}

################################################################################

_test(){
    ${PHP_PREFIX}/bin/php -v

    sudo ln -sf ${PHP_PREFIX}/bin/php /usr/local/sbin/php

    ${PHP_PREFIX}/bin/composer --ansi --version --no-interaction || echo ; sudo rm -rf /usr/local/sbin/php

    ${PHP_PREFIX}/bin/php -i | grep .ini

    ${PHP_PREFIX}/sbin/php-fpm -v

    sudo ${PHP_PREFIX}/bin/php-config >> ${PHP_INSTALL_LOG} || echo > /dev/null 2>&1

    set +x
    for ext in `ls /usr/local/src/php-${PHP_VERSION}/ext`; \
    do echo '*' $( ${PHP_PREFIX}/bin/php -r "if(extension_loaded('$ext')){echo '[x] $ext';}else{echo '[ ] $ext';}" ); done
    set -x
}

################################################################################

_builder(){

# 3. bug

# configure: error: Cannot find imap library (libc-client.a). Please check your c-client installation.
#
# https://blog.csdn.net/alexdream/article/details/7408453
#

     sudo ln -sf /usr/lib64/libc-client.so.2007 /usr/lib/libc-client.so

#
# configure: error: Cannot find ldap libraries in /usr/lib.
#
# @link https://blog.csdn.net/ei__nino/article/details/8598490

     sudo cp -frp /usr/lib64/libldap* /usr/lib/

# 4. configure

    CONFIGURE="--prefix=${PHP_PREFIX} \
        --sysconfdir=${PHP_INI_DIR} \
        \
        --build=${build:-x86_64-linux-gnu} \
        --host=${host:-x86_64-linux-gnu} \
        \
        --with-config-file-path=${PHP_INI_DIR} \
        --with-config-file-scan-dir=${PHP_INI_DIR}/conf.d \
        --disable-cgi --enable-fpm --with-fpm-user=nginx --with-fpm-group=nginx \
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
        \
        $( test $PHP_NUM = "56" && echo "--enable-opcache --enable-gd-native-ttf" ) \
        $( test $PHP_NUM = "70" && echo "--enable-gd-native-ttf --with-webp-dir=/usr/lib" ) \
        $( test $PHP_NUM = "71" && echo "--enable-gd-native-ttf --with-webp-dir=/usr/lib" ) \
       \
       $( if [ $PHP_NUM = "72" ];then \
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
        --enable-fileinfo=shared \
        --with-ldap=shared \
            --with-ldap-sasl \
        --enable-phar \
        --enable-posix=shared \
        --with-pspell=shared \
        --enable-shmop=shared \
        --enable-wddx=shared \
        "

    for a in ${CONFIGURE} ; do echo $a >> ${PHP_INSTALL_LOG}; done

    cd /usr/local/src/php-${PHP_VERSION}

    export CFLAGS="$PHP_CFLAGS"
    export CPPFLAGS="$PHP_CPPFLAGS"
    export LDFLAGS="$PHP_LDFLAGS"

    ./configure ${CONFIGURE}

# 5. make

    make -j "$(nproc)"

# 6. make install

    sudo rm -rf ${PHP_PREFIX} || echo

    if [ -d ${PHP_INI_DIR} ];then sudo mv ${PHP_INI_DIR} ${PHP_INI_DIR}.$( date +%s ).backup; fi

    sudo make install

################################################################################

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

_install_pecl_ext(){

    #
    # https://github.com/docker-library/php/issues/443
    #

    sudo ${PHP_PREFIX}/bin/pecl update-channels

    ${PHP_PREFIX}/bin/php-config >> ${PHP_INSTALL_LOG} || echo > /dev/null 2>&1

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
        sudo ${PHP_PREFIX}/bin/pecl install $extension > /dev/null || echo
    done
}

_php_ext_enable(){

echo "date.timezone=${PHP_TIMEZONE:-PRC}" | sudo tee ${PHP_INI_DIR}/conf.d/date_timezone.ini
echo "error_log=/var/log/php${PHP_NUM}.error.log" | sudo tee ${PHP_INI_DIR}/conf.d/error_log.ini
echo "session.save_path = \"/tmp\"" | sudo tee ${PHP_INI_DIR}/conf.d/session.ini

wsl-php-ext-enable.sh pdo_pgsql \
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
                      fileinfo \
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
                      $( test $PHP_NUM != "56" && echo "swoole" ) \
                      yaml \
                      opcache

# config opcache

echo 'opcache.enable_cli=1' >> ${PHP_INI_DIR}/conf.d/wsl-php-ext-opcache.ini
echo 'opcache.file_cache=/tmp' >> ${PHP_INI_DIR}/conf.d/wsl-php-ext-opcache.ini
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
    && ${PHP_PREFIX}/bin/php /tmp/installer.php --no-ansi --install-dir=${PHP_PREFIX}/bin --filename=composer --version=${COMPOSER_VERSION}
}

_test

_install_pecl_ext

_php_ext_enable

_create_log_file

_composer

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
  cd /usr/local ; sudo tar -zcvf php${PHP_NUM}.tar.gz php${PHP_NUM}

  cd etc ; sudo tar -zcvf php${PHP_NUM}-etc.tar.gz php${PHP_NUM}

  sudo mv ${PHP_PREFIX}.tar.gz /

  sudo mv ${PHP_INI_DIR}-etc.tar.gz /
}

################################################################################

_rpm(){

cd /tmp

echo "Name:       khs1994-wsl-php
Version:    ${PHP_VERSION}
Release:    1.el${VERSION_ID}.centos
Summary:    PHP scripting language for creating dynamic web sites

License:    PHP and Zend and BSD
URL:        https://github.com/khs1994-docker/lnmp/tree/master/wsl

# BuildRequires:
Requires:   $( echo ${PHP_DEP} | sed "s# #, #g" )

%description
PHP is an HTML-embedded scripting language. PHP attempts to make it
easy for developers to write dynamically generated web pages. PHP also
offers built-in database integration for several commercial and
non-commercial database management systems, so writing a
database-enabled webpage with PHP is fairly simple. The most common
use of PHP coding is probably as a replacement for CGI scripts.
The php package contains the module (often referred to as mod_php)
which adds support for the PHP language to Apache HTTP Server.

%pre
if [ -d ${PHP_INI_DIR} ];then sudo mv ${PHP_INI_DIR} ${PHP_INI_DIR}.\$( date +%s ).backup; fi
echo -e \"----------------------------------------------------------------------
\n
\n
Thanks for using khs1994-wsl-php !\n
Please find the official documentation for khs1994-wsl-php here:
* https://github.com/khs1994-docker/lnmp/tree/master/wsl\n
Meet issue? please see:
* https://github.com/khs1994-docker/lnmp/issues
\n
\n
----------------------------------------------------------------------
\n\n\"
%post
for file in \$( ls ${PHP_PREFIX}/bin ); do sudo ln -sf ${PHP_PREFIX}/bin/\$file /usr/local/bin/ ; done
ln -sf ${PHP_PREFIX}/sbin/php-fpm /usr/local/sbin/
echo > /dev/null
cd /var/log
if ! [ -f php${PHP_NUM}.error.log ];then touch php${PHP_NUM}.error.log ; fi
if ! [ -f php${PHP_NUM}-fpm.error.log ];then touch php${PHP_NUM}-fpm.error.log ; fi
if ! [ -f php${PHP_NUM}-fpm.access.log ];then touch php${PHP_NUM}-fpm.access.log ; fi
if ! [ -f php${PHP_NUM}-fpm.slow.log ];then touch php${PHP_NUM}-fpm.slow.log; fi
chmod 777 php${PHP_NUM}*
%preun
echo
echo \"Meet issue? Please see https://github.com/khs1994-docker/lnmp/issues \"
echo
%build
%install
rm -rf %{buildroot}
ls -la %{buildroot}/../ || echo
mkdir -p %{buildroot} || echo
mkdir -p %{buildroot}/usr/local/etc || echo
cp -a ${PHP_PREFIX} %{buildroot}/${PHP_PREFIX}
cp -a ${PHP_INI_DIR} %{buildroot}/${PHP_INI_DIR}
%files
%defattr (-,root,root,-)
${PHP_PREFIX}
${PHP_INI_DIR}
%changelog
%clean
RPM_NAME=khs1994-wsl-php-%{version}-%{release}.x86_64.rpm
cp -a %{buildroot}/../../RPMS/x86_64/\${RPM_NAME} ~
" > khs1994-wsl-php.spec

cat /tmp/khs1994-wsl-php.spec

rpmbuild -bb /tmp/khs1994-wsl-php.spec

RPM_NAME=khs1994-wsl-php-${PHP_VERSION}-1.el${VERSION_ID}.centos.x86_64.rpm

echo "$ sudo yum install -y ${RPM_NAME}"

cp ~/${RPM_NAME} /

sudo rm -rf $PHP_PREFIX

sudo rm -rf $PHP_INI_DIR

sudo yum install -y /${RPM_NAME}

# test

_test
}

################################################################################

if [ -z "$1" ];then _print_help_info ; else PHP_VERSION="$1" ; fi

set -ex

command -v wget || sudo yum install -y wget

mkdir -p /tmp/php-builder || echo

if [ "$PHP_VERSION" = 'rpm' ];then PHP_VERSION=7.2.5 ; fi

_get_phpnum $PHP_VERSION

export PHP_PREFIX=/usr/local/php${PHP_NUM}

export PHP_INI_DIR=/usr/local/etc/php${PHP_NUM}

# verify os

. /etc/os-release

#
# ID="centos"
# VERSION_ID="7"
#
# ID=fedora
# VERSION_ID=27
#

sudo yum install -y libargon2-devel > /dev/null 2>&1 || export ARGON2=false

_install_php_run_dep

if [ "$1" = yum ];then _install_php_build_dep ; exit $? ; fi

_install_php_build_dep

for command in "$@"
do
  test $command = '--skipbuild' && export SKIP_BUILD=1
done

test "${SKIP_BUILD}" != 1 && ( _download_src ; _builder ; _test ; _write_version_to_file )

for command in "$@"
do
  test $command = 'tar' && _tar
  test $command = 'rpm' && _rpm
done

ls -la /*.tar.gz

ls -la /*.rpm
