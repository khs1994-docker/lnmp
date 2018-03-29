#!/usr/bin/env bash

if [ -z $APP_ENV ];then
  echo "APP_ENV=wsl" >> ~/.bash_profile
fi
