#!/bin/bash

# 构建镜像

cd dockerfile/laravel

docker build -t lnmp-laravel .

echo -e "\033[32mINFO\033[0m mkdir log folder\n"

cd ../laravel-artisan

docker build -t lnmp-laravel-artisan .

echo -e "\033[32mINFO\033[0m mkdir log folder\n"
