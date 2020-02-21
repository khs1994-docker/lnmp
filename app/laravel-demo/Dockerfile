# 此 Dockerfile 使用了多阶段构建，同时构建了 PHP 及 NGINX 两个镜像
#
# @link https://docs.docker.com/engine/reference/builder/
# @link https://docs.docker.com/develop/develop-images/multistage-build/
# @link https://laravel-news.com/multi-stage-docker-builds-for-laravel
#
# 只有 git 打了 tag 才能将对应的镜像部署到生产环境
#
# !! 搜索 /app/laravel-docker 替换为自己的项目目录 !!
# 此 Dockerfile 专为 CI 环境设计（国外），请通过 --build-arg ARG=value 设置国内镜像
#
# $ docker build --target=laravel -t khs1994/laravel:6.0 --build-arg NODE_REGISTRY=https://registry.npm.taobao.org --build-arg CI=false .

ARG NODE_VERSION=13.8.0
ARG PHP_VERSION=7.4.3
ARG NGINX_VERSION=1.15.0
ARG DOCKER_HUB_USERNAME=khs1994

# 1.前端构建，建议放到 CDN，可省略此步
FROM node:${NODE_VERSION:-13.8.0}-alpine as frontend

ARG NODE_REGISTRY=https://registry.npmjs.org

# COPY package.json webpack.mix.js yarn.lock /app/
# COPY package.json webpack.mix.js package-lock.json /app/
COPY package.json webpack.mix.js /app/

RUN cd /app \
      # && yarn install \
      && npm install --registry=${NODE_REGISTRY}

COPY resources/ /app/resources/

RUN cd /app \
      && mkdir -p public \
      # && yarn production \
      && npm run production

# 2.安装 composer 依赖
FROM ${DOCKER_HUB_USERNAME:-khs1994}/php:7.4.3-composer-alpine as composer

# COPY composer.json composer.lock /app/
COPY composer.json /app/
COPY database/ /app/database/

ARG CI=true

RUN cd /app \
      && test $CI = 'true' && composer config -g --unset repos.packagist || true \
      && composer install --no-dev \
             --ignore-platform-reqs \
             --prefer-dist \
             --no-interaction \
             --no-scripts \
             --no-plugins

# 3.将项目打入 PHP 镜像
# $ docker build -t khs1994/laravel:TAG --target=laravel .
FROM ${DOCKER_HUB_USERNAME:-khs1994}/php:${PHP_VERSION}-fpm-alpine as laravel

COPY . /app/laravel-docker/
COPY --from=composer /app/vendor/ /app/laravel-docker/vendor/
COPY --from=frontend /app/public/js/ /app/laravel-docker/public/js/
COPY --from=frontend /app/public/css/ /app/laravel-docker/public/css/
COPY --from=frontend /app/mix-manifest.json /app/laravel-docker/mix-manifest.json

VOLUME /app/laravel-docker/storage/framework/views

CMD ["php-fpm", "-R"]

# 4.将 PHP 项目打入 NGINX 镜像
# Nginx 配置文件统一通过 configs 管理，严禁将配置文件打入镜像
# $ docker build -t khs1994/laravel:TAG-nginx .

# FROM ${DOCKER_HUB_USERNAME:-khs1994}/laravel:TAG-nginx
FROM nginx:${NGINX_VERSION} as nginx

COPY --from=laravel /app/ /app/

ADD https://raw.githubusercontent.com/khs1994-docker/lnmp-nginx-conf-demo/master/wait-for-php.sh /wait-for-php.sh

RUN rm -rf /etc/nginx/conf.d \
    && chmod +x /wait-for-php.sh

CMD ["/wait-for-php.sh"]
