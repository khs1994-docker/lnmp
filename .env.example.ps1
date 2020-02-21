# You Can overwrite this file in .env.ps1

# privacy info, please set true to help us improve
$DATA_COLLECTION="true"

$APP_ENV="windows"
$APP_ROOT="./app"
# $APP_ROOT="../app"

$LREW_INCLUDE="pcit","minio"
# $LREW_INCLUDE="pcit","minio"

$LNMP_SERVICES='nginx','mysql','php7','redis','phpmyadmin'

# LNMP_SERVICES="nginx","mysql","mariadb","php7","redis","phpmyadmin",`
#                      "memcached","postgresql","mongodb",`
#                      "rabbitmq","httpd","registry",`
#                      "minio",`
#                      "supervisord",`
#                      "nginx-unit", `
#                      "kong","postgresql-kong","konga"

$CI_HOST="ci.khs1994.com:10000"

# wsl name
# $ wslconfig /l
# $ wsl -l
$DistributionName="Ubuntu-18.04"

$TZ='Asia/Shanghai'

$LNMP_PHP_IMAGE="khs1994/php:7.4.3-composer-alpine"

$HYPERV_VIRTUAL_SWITCH='zy'

$NGINX_PATH="C:/nginx"
$PHP_PATH="C:/php"

$LNMP_PATH="$HOME/lnmp"

$COMMON_SOFT="nginx","php","mysql","wsl-redis"

$LNMP_NODE_IMAGE="node:alpine"
# $LNMP_NODE_IMAGE="khs1994/node:git"

$LNMP_WSL2_DOCKER_HOST="tcp://localhost:2375"

# $LNMP_CACHE=
