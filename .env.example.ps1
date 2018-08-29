#
# You Can overwrite this file in .env.ps1
#

$global:DEVELOPMENT_INCLUDE='nginx','mysql','php7','redis','phpmyadmin'

# DEVELOPMENT_INCLUDE="nginx mysql mariadb php7 redis phpmyadmin \
#                      memcached postgresql mongodb \
#                      rabbitmq httpd registry \
#                      gogs gitlab etcd \
#                      "

$global:CI_HOST="ci.khs1994.com:10000"

# wsl name $ wslconfig /l
$global:DistributionName="debian"

$global:TZ='Asia/Shanghai'

#
# You can overwrite this file in .env.ps1
#

$global:LNMP_PHP_IMAGE="khs1994/php:7.2.9-fpm-alpine"

$global:HYPERV_VIRTUAL_SWITCH='zy'

$NGINX_PATH="C:/nginx"
$PHP_PATH="C:/php"

$LNMP_PATH="$HOME/lnmp"

$DistributionName="debian"

$COMMON_SOFT="nginx","php","mysql","wsl-redis"

$global:NGINX_VERSION="1.15.3"
# https://windows.php.net/download/
$global:PHP_VERSION="7.2.9"
$global:MYSQL_VERSION="8.0.12"
$global:HTTPD_VERSION="2.4.34"
$global:IDEA_VERSION="1.10.4088"
$global:NODE_VEERSION="10.6.0"
$global:GIT_VERSION="2.18.0"
$global:PYTHON_VERSION="3.7.0"
$global:GOLANG_VERSION="1.11"
$global:HTTPD_MOD_FCGID_VERSION="2.3.9"
$global:ZEAL_VERSION="0.5.0"

$global:APP_ENV="windows"

$global:PHP_REDIS_EXTENSION_VERSION="4.1.0"
$global:PHP_MONGODB_EXTENSION_VERSION="1.5.1"
$global:PHP_IGBINARY_EXTENSION_VERSION="2.0.7"
$global:PHP_XDEBUG_EXTENSION_VERSION="2.7.0alpha1"
$global:PHP_YAML_EXTENSION_VERSION="2.0.2"
$global:PHP_CACERT_DATA="2018-06-20"
