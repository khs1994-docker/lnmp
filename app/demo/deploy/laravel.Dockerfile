# 此 Dockerfile 使用了多阶段构建，同时构建了 PHP 及 NGINX 两个镜像
#
# @link https://docs.docker.com/engine/reference/builder/
# @link https://docs.docker.com/develop/develop-images/multistage-build/
# @link https://laravel-news.com/multi-stage-docker-builds-for-laravel
#
# 约定，只有 git 打了 tag 才能将对应的镜像部署到生产环境
#
# !! 搜索 /app/EXAMPLE 替换为自己的项目目录 !!

ARG NODE_VERSION=11.1.0
ARG PHP_VERSION=7.2.12
ARG NGINX_VERSION=1.15.6
ARG DOCKER_HUB_USERNAME=khs1994

# 1.安装前端依赖
FROM node:${NODE_VERSION:-11.1.0}-alpine as frontend_install

# COPY package.json webpack.mix.js yarn.lock /app/
COPY package.json webpack.mix.js package-lock.json /app/

RUN cd /app/EXAMPLE \
      # && yarn install \
      && npm install --production

# 2.运行前端脚本
FROM node:${NODE_VERSION:-11.1.0}-alpine as frontend

COPY --from=frontend_install /app/EXAMPLE /app/EXAMPLE
COPY resources/assets/ /app/resources/assets/

RUN cd /app/EXAMPLE \
      && set PATH=./node_modules/.bin:$PATH
      # && yarn production \
      && npm run production

# 3.安装 composer 依赖
FROM ${DOCKER_HUB_USERNAME:-khs1994}/php:7.2.12-composer-alpine as composer

COPY composer.json composer.lock /app/EXAMPLE/

RUN cd /app/EXAMPLE \
      # 安装 composer 依赖
      && if [ -f composer.json ];then \
           echo "Composer packages installing..."; \
           composer install --no-dev \
             --ignore-platform-reqs \
             --prefer-dist \
             --no-interaction \
           ; echo "Composer packages install success"; \
         else \
           echo "composer.json NOT exists"; \
         fi

# 4.将项目打入 PHP 镜像
# $ docker build -t khs1994/php:7.2.12-pro-GIT_TAG-alpine --target=php .

FROM ${DOCKER_HUB_USERNAME:-khs1994}/php:${PHP_VERSION}-fpm-alpine as php

COPY . /app/EXAMPLE
COPY --from=composer /app/EXAMPLE/vendor/ /app/EXAMPLE/vendor/
COPY --from=frontend /app/public/js/ /app/EXAMPLE/public/js/
COPY --from=frontend /app/public/css/ /app/EXAMPLE/public/css/
COPY --from=frontend /app/mix-manifest.json /app/EXAMPLE/mix-manifest.json

CMD ["php-fpm", "-R"]

# 5.将 PHP 项目打入 NGINX 镜像
# Nginx 配置文件统一通过 configs 管理，严禁将配置文件打入镜像
# $ docker build -t khs1994/nginx:1.15.6-pro-GIT_TAG-alpine .

# FROM ${DOCKER_HUB_USERNAME:-khs1994}/nginx:1.15.6-alpine
FROM nginx:${NGINX_VERSION} as nginx

COPY --from=php /app /app

ADD https://raw.githubusercontent.com/khs1994-docker/lnmp-nginx-conf-demo/master/wait-for-php.sh /wait-for-php.sh

RUN rm -rf /etc/nginx/conf.d \
    && chmod +x /wait-for-php.sh

CMD ["/wait-for-php.sh"]
