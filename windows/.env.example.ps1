#
# You can overwrite this file in .env.ps1
#

$global:LNMP_PHP_IMAGE="khs1994/php:7.2.8-fpm-alpine"

$global:HYPERV_VIRTUAL_SWITCH='zy'

$NGINX_PATH="C:/nginx"
$PHP_PATH="C:/php"

$LNMP_PATH="$HOME/lnmp"

$DistributionName="debian"

$COMMON_SOFT="nginx","php","mysql","wsl-redis"

$global:NGINX_VERSION="1.15.2"
# https://windows.php.net/download/
$global:PHP_VERSION="7.2.8"
$global:MYSQL_VERSION="8.0.11"
$global:HTTPD_VERSION="2.4.34"
$global:IDEA_VERSION="1.9.3935"
$global:NODE_VEERSION="10.6.0"
$global:GIT_VERSION="2.18.0"
$global:PYTHON_VERSION="3.7.0"
$global:GOLANG_VERSION="1.10.3"
$global:HTTPD_MOD_FCGID_VERSION="2.3.9"
$global:ZEAL_VERSION="0.5.0"

$global:APP_ENV="windows"
