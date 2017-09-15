#!/bin/bash

# 构建镜像

cd dockerfile/laravel

docker build -t lnmp-laravel .

cd ../laravel-artisan

docker build -t lnmp-laravel-artisan .
