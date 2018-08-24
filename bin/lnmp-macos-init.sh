#!/usr/bin/env bash

set -e

if [ "$debug" = 'true' ];then set -x; fi

SOFT=" php \
composer \
php-cs-fixer \
nginx \
memcached \
postgresql \
mongodb \
fish \
git \
python \
node \
libmemcached \
libyaml \
pkg-config \
openssl \
openssl@1.1 \
coreos-ct \
gnu-sed \
tree \
wget \
"

PECL=" igbinary \
yaml \
xdebug \
redis \
mongodb \
memcached \
"

_install_brew(){
  command -v gcc || exit $?

  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

_brew(){
  command -v brew || _install_brew

  for soft in $SOFT
  do
    ( brew list | grep $soft ) || brew install $soft
  done
}

_pecl(){
  for soft in $PECL
  do
  test ! $soft = 'mongodb' || sudo ln -sf /usr/local/opt/openssl/include/openssl /usr/local/include/
  ( pecl list | grep $soft ) || pecl install $soft
  done
}

_fish(){
  if ![ -d ~/git/oh-my-fish ];then
    git clone --depth=1 https://github.com/oh-my-fish/oh-my-fish.git ~/git/oh-my-fish
  fi
}

_file(){
    ( cat $1 | grep $2 ) || echo -e $3 >> $1
}

_ruby(){
  gem sources -l | grep https://gems.ruby-china.org/ || gem sources -a https://gems.ruby-china.org/ ; gem sources -l
}

_env(){
  cat /etc/shells | grep fish || echo /usr/local/bin/fish | sudo tee -a /etc/shells
}

_composer(){
  composer config -g repo.packagist composer https://packagist.phpcomposer.com
}

_mkdir(){
  if ! [ -d $1 ];then mkdir -p $1 ; fi
}

_brew

_pecl

_ruby

_env

_file ~/.npmrc "registry=https://registry.npm.taobao.org" "registry=https://registry.npm.taobao.org"

_mkdir ~/.pip

_file ~/.pip/pip.conf "index-url = https://pypi.douban.com/simple" "[global]\nindex-url = https://pypi.douban.com/simple\n[list]\nformat=columns"
