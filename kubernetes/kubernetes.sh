#!/usr/bin/env bash

if [ "$1" = cleanup ];then

kubectl delete deployment -l app=lnmp

kubectl delete service -l app=lnmp

kubectl delete pvc -l app=lnmp

kubectl delete pv lnmp-mysql-data lnmp-redis-data lnmp-data

kubectl delete secret lnmp-mysql-password

kubectl delete configmap lnmp-env

elif [ "$1" = deploy ];then

  kubectl create -f lnmp-volumes.yaml

  kubectl create -f lnmp-env.yaml

  kubectl create secret generic lnmp-mysql-password --from-literal=password=mytest

  kubectl create -f lnmp-mysql.yaml

  kubectl create -f lnmp-redis.yaml

  kubectl create -f lnmp-php7.yaml

  kubectl create -f lnmp-nginx.yaml
else
  echo "Usage:	$0 COMMAND

Commands:
  deploy
  cleanup"
fi
