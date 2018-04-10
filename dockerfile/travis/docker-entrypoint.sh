#!/bin/sh

if [ "$1" = 'bash' ] || [ "$1" = 'sh' ];then
  exec sh
fi

if ! [ -f /root/.travis/config.yml ];then

travis whoami || travis login --github-token $GITHUB_TOKEN

fi

exec travis "$@"
