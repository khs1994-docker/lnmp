#!/usr/bin/env bash

set -ex

command -v curl || sudo apt install curl tar

DOCKER_VERSION=18.03.0-ce

# DOCKER_VERSION=18.03.0-ce-rc1

download_docker(){
  curl -SL http://mirrors.ustc.edu.cn/docker-ce/linux/static/test/x86_64/docker-${DOCKER_VERSION}.tgz | tar -zxvf -
}

if [ -d docker ];then
  DOCKER_CURRENT_VERSION=$( docker/docker --version | cut -d ' ' -f 3 )

  if [ $DOCKER_VERSION, != $DOCKER_CURRENT_VERSION ];then
    download_docker
  fi

else
  download_docker
fi

sudo cp docker/docker /usr/local/bin/docker

if [ -z $DOCKER_HOST ];then
  echo "export DOCKER_HOST=tcp://127.0.0.1:2375" >> ~/.bash_profile
fi

# 命令行补全

if ! [ -d /etc/bash_completion.d ];then sudo mkdir -p /etc/bash_completion.d; fi

if ! [ -f /etc/bash_completion.d/docker ];then

sudo curl -L https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker

fi

# verify

docker --version
