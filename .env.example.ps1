# You Can overwrite this file in .env.ps1

# privacy info, please set true to help us improve
$global:DATA_COLLECTION="true"

$global:APP_ENV="windows"
$global:APP_ROOT="./app"
# $global:APP_ROOT="../app"

$global:LNMP_SERVICES='nginx','mysql','php7','redis','phpmyadmin'

# LNMP_SERVICES="nginx mysql mariadb php7 redis phpmyadmin \
#                      memcached postgresql mongodb \
#                      rabbitmq httpd registry \
#                      etcd \
#                      minio \
#                      supervisord \
#                      nginx-unit \
#                      "

$global:CI_HOST="ci.khs1994.com:10000"

# wsl name $ wslconfig /l
$global:DistributionName="debian"

$global:TZ='Asia/Shanghai'

$global:LNMP_PHP_IMAGE="khs1994/php:7.3.9-composer-alpine"

$global:HYPERV_VIRTUAL_SWITCH='zy'

$NGINX_PATH="C:/nginx"
$PHP_PATH="C:/php"

$LNMP_PATH="$HOME/lnmp"

$COMMON_SOFT="nginx","php","mysql","wsl-redis"

$global:LNMP_NODE_IMAGE="node:alpine"
# $global:LNMP_NODE_IMAGE="khs1994/node:git"

$global:LREW_INCLUDE="etcd","pcit"
# $global:LREW_INCLUDE="etcd","pcit","minio"
