#!/usr/bin/env bash
cd app

git clone -b master git@git.qcloud.com:khs1994-website/admin.git

git clone -b gh-pages git@code.aliyun.com:khs1994-website/blog.git

git clone -b gh-pages git@code.aliyun.com:khs1994-website/html.git

git clone -b gh-pages git@code.aliyun.com:khs1994-website/docs.git doc

git clone -b gh-pages git@code.aliyun.com:khs1994-website/php-docs.git

git clone -b master git@code.aliyun.com:khs1994/www.khs1994.git www

git clone -b gh-pages git@code.aliyun.com:xc725-wang/blog.git xc725/blog

git clone -b master git@code.aliyun.com:xc725-wang/xc725.wang.git xc725/www
