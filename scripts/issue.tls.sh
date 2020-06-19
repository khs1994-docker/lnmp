#!/bin/bash

if [ $1 = 'rsa' ];then
  lnmp-docker ssl khs1994.com -d *.khs1994.com \
                     -d *.developer.khs1994.com \
                     -d *.home.khs1994.com \
                     -d *.baidu.khs1994.com \
                     -d *.alibaba.khs1994.com \
                     -d *.tencent.khs1994.com \
                     -d *.cxyl.khs1994.com \
                     -d *.ci.khs1994.com \
                     -d *.ci2.khs1994.com \
                     -d *.mirrors.khs1994.com -d *.mirror.khs1994.com \
                     -d docker-practice.com -d *.docker-practice.com \
                     --rsa
fi

lnmp-docker ssl khs1994.com -d *.khs1994.com \
                   -d *.developer.khs1994.com \
                   -d *.home.khs1994.com \
                   -d *.baidu.khs1994.com \
                   -d *.alibaba.khs1994.com \
                   -d *.tencent.khs1994.com \
                   -d *.ci.khs1994.com \
                   -d *.ci2.khs1994.com \
                   -d *.mirrors.khs1994.com -d *.mirror.khs1994.com \
                   -d docker-practice.com -d *.docker-practice.com \
                   -d *.cxyl.khs1994.com
