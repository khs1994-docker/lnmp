# privacy info, please set true to help us improve

$global:DATA_COLLECTION="true"

#
# You Can overwrite this file in .env.ps1
#

$global:LNMP_INCLUDE='nginx','mysql','php7','redis','phpmyadmin'

# LNMP_INCLUDE="nginx mysql mariadb php7 redis phpmyadmin \
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

#
# You can overwrite this file in .env.ps1
#

$global:LNMP_PHP_IMAGE="khs1994/php:7.3.6-composer-alpine"

$global:HYPERV_VIRTUAL_SWITCH='zy'

$NGINX_PATH="C:/nginx"
$PHP_PATH="C:/php"

$LNMP_PATH="$HOME/lnmp"

$DistributionName="debian"

$COMMON_SOFT="nginx","php","mysql","wsl-redis"

$global:NGINX_VERSION="1.17.1"
# https://windows.php.net/download/
$global:PHP_VERSION="7.3.6"
$global:MYSQL_VERSION="8.0.16"
$global:HTTPD_VERSION="2.4.39"
$global:HTTPD_MOD_FCGID_VERSION="2.3.10"
$global:NODE_VERSION="12.5.0"
$global:GIT_VERSION="2.22.0"
$global:GOLANG_VERSION="1.13beta1"
# $global:GOLANG_VERSION="1.12rc1"
# $global:GOLANG_VERSION="1.12.5"

$global:APP_ENV="windows"
$global:APP_ROOT="./app"
# $global:APP_ROOT="../app"

$global:PHP_REDIS_EXTENSION_VERSION="4.3.0"
$global:PHP_MONGODB_EXTENSION_VERSION="1.5.5"
$global:PHP_IGBINARY_EXTENSION_VERSION="3.0.1"
$global:PHP_XDEBUG_EXTENSION_VERSION="2.7.2"
$global:PHP_YAML_EXTENSION_VERSION="2.0.4"
# https://curl.haxx.se/docs/caextract.html
$global:PHP_CACERT_DATE="2019-05-15"
