#!/usr/bin/env bash

if [[ "$PHP_VERSION" = "nightly" && "$FPM" = "1" ]];then
  images=("$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}-fpm")
  images[1]="$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}"
  images[2]="$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}-alpine"

  for image in ${images[@]} ;
  do
    fpmTagOptions+=" -t $image "
  done
fi

if [[ "$PHP_VERSION" = "7_1_X" && "$FPM" = "1" ]];then
  images=("$DOCKER_HUB_USERNAME/php:7.1-fpm-alpine")
  images[1]="$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}"
  images[2]="$DOCKER_HUB_USERNAME/php:7.1"
  images[3]="$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}-alpine"
  images[4]="$DOCKER_HUB_USERNAME/php:7.1-alpine"
  images[5]="$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}-fpm"
  images[6]="$DOCKER_HUB_USERNAME/php:7.1-fpm"

  for image in ${images[@]} ;
  do
    fpmTagOptions+=" -t $image "
  done
fi

if [[ "$PHP_VERSION" = "7_2_X" && "$FPM" = "1" ]];then
  images=("$DOCKER_HUB_USERNAME/php:7.2-fpm-alpine")
  images[1]="$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}"
  images[2]="$DOCKER_HUB_USERNAME/php:7.2"
  images[3]="$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}-alpine"
  images[4]="$DOCKER_HUB_USERNAME/php:7.2-alpine"
  images[5]="$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}-fpm"
  images[6]="$DOCKER_HUB_USERNAME/php:7.2-fpm"

  for image in ${images[@]} ;
  do
    fpmTagOptions+=" -t $image "
  done
fi

if [[ "$PHP_VERSION" = "7_3_X" && "$FPM" = "1" ]];then
  images=("$DOCKER_HUB_USERNAME/php:7.3-fpm-alpine")
  images[1]="$DOCKER_HUB_USERNAME/php:7-fpm-alpine"
  images[2]="$DOCKER_HUB_USERNAME/php:fpm-alpine"
  images[3]="$DOCKER_HUB_USERNAME/php:alpine"
  images[4]="$DOCKER_HUB_USERNAME/php"
  images[5]="$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}"
  images[6]="$DOCKER_HUB_USERNAME/php:7.3"
  images[7]="$DOCKER_HUB_USERNAME/php:7"
  images[8]="$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}-alpine"
  images[9]="$DOCKER_HUB_USERNAME/php:7.3-alpine"
  images[10]="$DOCKER_HUB_USERNAME/php:7-alpine"
  images[11]="$DOCKER_HUB_USERNAME/php:${PHP_TAG_VERSION}-fpm"
  images[12]="$DOCKER_HUB_USERNAME/php:7.3-fpm"
  images[13]="$DOCKER_HUB_USERNAME/php:7-fpm"
  images[14]="$DOCKER_HUB_USERNAME/php:fpm"

  for image in ${images[@]} ;
  do
    fpmTagOptions+=" -t $image "
  done
fi

echo $fpmTagOptions

# wget https://raw.githubusercontent.com/khs1994-docker/lnmp/19.03/scripts/arm-build.sh
# chmod +x arm-build.sh
#
# if [[ "$PHP_VERSION" = "7_3_X" && "$FPM" = "1" ]];then
#   # docker pull khs1994/php:${PHP_TAG_VERSION}-fpm-alpine
#   # docker pull khs1994/php:${PHP_TAG_VERSION}-composer-alpine
#
#   ./arm-build.sh manifest 7.3.6 fpm || true
# fi
#
# if [[ "$PHP_VERSION" = "7_3_X" && "$COMPOSER" = "1" ]];then
#   # docker pull khs1994/php:${PHP_TAG_VERSION}-fpm-alpine
#   # docker pull khs1994/php:${PHP_TAG_VERSION}-composer-alpine
#
#   ./arm-build.sh manifest 7.3.6 composer || true
# fi
