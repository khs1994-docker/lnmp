#!/usr/bin/env bash

print_help_info(){
echo "

Usage:

manifest  [7.3.3] [TYPE:fpm | composer | unit | swoole | supervisord ]
build     [7.3.3] [ arm32v7 | arm64v8 ] [7.3/alpine] [TYPE: fpm | ... ]

"
}

export DOCKER_BUILDKIT=1
export DOCKER_CLI_EXPERIMENTAL=enabled

build(){
  local version=$1
  local arch=$2
  local folder=$3
  local type=$4

case "${type}" in
  fpm | swoole )
    image=${arch}/php
    ;;
  composer | supervisord )
    image=khs1994/${arch}-php
    ;;
  unit )
    image=${arch}/alpine
    ;;

esac

cd dockerfile/php-fpm/${folder}
docker build -t khs1994/${arch}-php:${version}-${type}-alpine \
  --build-arg IMAGE=${image} \
  --build-arg ALPINE_URL=mirrors.ustc.edu.cn \
  --build-arg PHP_VERSION=${version} \
  --progress plain \
  .
cd -

docker push khs1994/${arch}-php:${version}-${type}-alpine
}

manifest(){
  local version=$1
  local type=$2

docker pull khs1994/php:${version}-${type}-alpine

docker manifest create khs1994/php:${version}-${type}-alpine \
    khs1994/php:${version}-${type}-alpine \
    khs1994/arm32v7-php:${version}-${type}-alpine \
    khs1994/arm64v8-php:${version}-${type}-alpine -a

docker manifest annotate khs1994/php:${version}-${type}-alpine \
    khs1994/php:${version}-${type}-alpine \
    --os linux --arch amd64

docker manifest annotate khs1994/php:${version}-${type}-alpine \
    khs1994/arm32v7-php:${version}-${type}-alpine \
    --os linux --arch arm --variant v7

docker manifest annotate khs1994/php:${version}-${type}-alpine \
    khs1994/arm64v8-php:${version}-${type}-alpine \
    --os linux --arch arm64 --variant v8

docker manifest inspect khs1994/php:${version}-${type}-alpine

sleep 10

docker manifest push khs1994/php:${version}-${type}-alpine
}

if [ "$1" = '--help' ];then
  print_help_info
  exit
fi

set -x

if [ "$1" = 'manifest' ];then
  manifest ${2:-7.3.3} ${3:-fpm}
  exit
fi

if [ "$1" = 'build' ];then
  build ${2:-7.3.3} ${3:-arm32v7} ${4:-7.3/alpine} ${5:-fpm}
  exit
fi

# build 7.2.16 arm32v7 7.2/alpine fpm
# build 7.2.16 arm64v8 7.2/alpine fpm

build 7.3.3 arm32v7 7.3/alpine fpm
build 7.3.3 arm32v7 7.3/composer composer

build 7.3.3 arm64v8 7.3/alpine fpm
build 7.3.3 arm64v8 7.3/composer composer

manifest 7.3.3 fpm
manifest 7.3.3 composer
