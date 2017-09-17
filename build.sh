#!/bin/bash

# 删除原有容器

docker rmi lnmp-laravel lnmp-laravel-artisan

# 构建单容器镜像

cd dockerfile/laravel

docker build -t lnmp-laravel .

echo -e "\033[32mINFO\033[0m build lnmp-laravel Success\n"

cd ../laravel-artisan

docker build -t lnmp-laravel-artisan .

echo -e "\033[32mINFO\033[0m build lnmp-laravel-artisan Success\n"
