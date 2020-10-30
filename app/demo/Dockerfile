# 此 Dockerfile 使用了多阶段构建，同时构建了 PHP 及 NGINX 两个镜像
#
# @link https://docs.docker.com/engine/reference/builder/
# @link https://docs.docker.com/develop/develop-images/multistage-build/
# @link https://laravel-news.com/multi-stage-docker-builds-for-laravel
#
# 只有 git 打了 tag 才能将对应的镜像部署到生产环境
#
# !! 搜索 /app/EXAMPLE 替换为自己的项目目录 !!

ARG NODE_VERSION=15.0.1
ARG PHP_VERSION=7.4.12
ARG NGINX_VERSION=1.15.0
ARG DOCKER_HUB_USERNAME=khs1994

# 1.安装 composer 依赖
FROM ${DOCKER_HUB_USERNAME:-khs1994}/php:${PHP_VERSION}-composer-alpine as composer

# COPY composer.json composer.lock /app/EXAMPLE/
COPY composer.json /app

RUN cd /app \
      && composer install --no-dev \
           --ignore-platform-reqs \
           --prefer-dist \
           --no-interaction \
           --no-scripts \
           --no-plugins

# 2.将项目打入 PHP 镜像
# $ docker build -t khs1994/php:7.4.12-pro-GIT_TAG-alpine --target=php .

FROM ${DOCKER_HUB_USERNAME:-khs1994}/php:${PHP_VERSION}-fpm-alpine as php

COPY . /app/EXAMPLE
COPY --from=composer /app/vendor/ /app/EXAMPLE/vendor/

CMD ["php-fpm", "-R"]

# 5.将 PHP 项目打入 NGINX 镜像
# Nginx 配置文件统一通过 configs 管理，严禁将配置文件打入镜像
# $ docker build -t khs1994/nginx:1.15.0-pro-GIT_TAG-alpine .

# FROM ${DOCKER_HUB_USERNAME:-khs1994}/nginx:1.15.0-alpine
FROM nginx:${NGINX_VERSION} as nginx

COPY --from=php /app /app

ADD https://raw.githubusercontent.com/khs1994-docker/lnmp-nginx-conf-demo/master/wait-for-php.sh /wait-for-php.sh

RUN rm -rf /etc/nginx/conf.d \
    && chmod +x /wait-for-php.sh

CMD ["/wait-for-php.sh"]
