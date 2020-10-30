# 此 Dockerfile 使用了多阶段构建，同时构建了 PHP 及 NGINX 两个镜像
#
# @link https://docs.docker.com/engine/reference/builder/
# @link https://docs.docker.com/develop/develop-images/multistage-build/
# @link https://laravel-news.com/multi-stage-docker-builds-for-laravel
#
# 只有 git 打了 tag 才能将对应的镜像部署到生产环境
#
# 为了方便读者阅读没有引入过多的变量，实际使用时可以将公共的部分用变量代替
#
# !! 搜索 /app/laravel-docker 替换为自己的项目目录 !!
# 此 Dockerfile 专为 CI 环境设计（国外），请通过 --build-arg ARG=value 设置国内镜像
#
# $ docker build --target=laravel -t khs1994/laravel:7 --build-arg NODE_REGISTRY=https://registry.npm.taobao.org --build-arg CI=false .

ARG NODE_VERSION=15.0.1
ARG PHP_VERSION=7.4.12
ARG NGINX_VERSION=1.19.3-alpine
ARG DOCKER_HUB_USERNAME=khs1994

# 1.前端构建
FROM node:${NODE_VERSION:-15.0.1}-alpine as frontend

ARG NODE_REGISTRY=https://registry.npmjs.org

# COPY package.json webpack.mix.js yarn.lock /app/
# COPY package.json webpack.mix.js package-lock.json /app/
COPY package.json webpack.mix.js /app/

RUN set -x ; cd /app \
      # && yarn install \
      && npm install --registry=${NODE_REGISTRY}

COPY resources/ /app/resources/

RUN set -x ; cd /app \
# File.exists('./artisan'); 如果 artisan 文件存在，则说明是 laravel 项目
      && touch artisan \
      && mkdir -p public \
      # && yarn production \
      && npm run production

# 2.安装 composer 依赖
FROM ${DOCKER_HUB_USERNAME}/php:7.4.12-composer-alpine as composer

# COPY composer.json composer.lock /app/
COPY composer.json /app/
COPY database/ /app/database/

ARG CI=true

RUN set -x ; cd /app \
      && composer config -g repos.packagist composer https://mirrors.aliyun.com/composer/ \
      && if [ $CI = 'true' ];then composer config -g --unset repos.packagist; fi \
      && composer install --no-dev \
             --ignore-platform-reqs \
             --prefer-dist \
             --no-interaction \
             --no-scripts \
             --no-plugins \
             --optimize-autoloader

# 3.将项目打入 PHP 镜像
# $ docker build -t khs1994/laravel:TAG --target=laravel .
FROM ${DOCKER_HUB_USERNAME}/php:${PHP_VERSION}-s6-alpine as laravel

COPY . /app/laravel-docker/
COPY --from=composer /app/vendor/ /app/laravel-docker/vendor/
COPY --from=frontend /app/public/js/ /app/laravel-docker/public/js/
COPY --from=frontend /app/public/css/ /app/laravel-docker/public/css/
COPY --from=frontend /app/public/mix-manifest.json /app/laravel-docker/public/mix-manifest.json

VOLUME /app/laravel-docker/storage/framework/views

ENTRYPOINT [ "sh", "/app/laravel-docker/.docker/docker-entrypoint.sh" ]

CMD ["php-fpm", "-R", "-F"]

# rootless 镜像
FROM ${DOCKER_HUB_USERNAME}/php:${PHP_VERSION}-s6-alpine as laravel-rootless

ARG CI=true

# https://github.com/gliderlabs/docker-alpine/issues/381
RUN set -x; \
    if ! [ "$CI" = 'true' ];then \
        sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories; \
    fi \
    && apk add --no-cache dcron libcap \
    && chown www-data:www-data /usr/sbin/crond \
    && setcap cap_setgid=ep /usr/sbin/crond

COPY --from=laravel /app/laravel-docker /app/laravel-docker

RUN set -x \
    && chmod -R +x /app/laravel-docker/.docker-rootless/s6 \
    && mkdir -p /app/laravel-docker/storage/app \
                /app/laravel-docker/storage/framework/views \
    && chown -R www-data:www-data /app/laravel-docker/public \
                                  /app/laravel-docker/.docker-rootless/s6 \
    && chown www-data:www-data \
                               /app/laravel-docker/bootstrap/cache \
                               /app/laravel-docker/storage/app \
                               /app/laravel-docker/storage/framework/views \
    \
    && echo 'rootless' > /app/laravel-docker/storage/app/rootless.txt

USER www-data

ENTRYPOINT [ "sh", "/app/laravel-docker/.docker-rootless/docker-entrypoint.sh" ]

# 4.将 PHP 项目打入 NGINX 镜像
# Nginx 配置文件统一通过 configs 管理，严禁将配置文件打入镜像
# $ docker build -t khs1994/laravel:TAG-nginx .

FROM nginx:${NGINX_VERSION} as nginx

COPY --from=laravel /app/laravel-docker/public /app/laravel-docker/public

ADD https://raw.githubusercontent.com/khs1994-docker/lnmp-nginx-conf-demo/master/wait-for-php.sh /wait-for-php.sh

RUN set -x ; rm -rf /etc/nginx/conf.d

ENTRYPOINT ["sh", "/wait-for-php.sh"]
