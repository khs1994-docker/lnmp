#!/bin/sh

if [ "$1" = 'bash' ] || [ "$1" = 'sh' ];then
  exec sh
fi

travis whoami || travis login --github-token $GITHUB_TOKEN

echo $@

exec travis "$@"
