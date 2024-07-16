# 本项目全局变量

# 是否为国内环境，默认为 true，当处于非国内环境(例如：GitHub Actions)时请改为 false
${env:LNMP_CN_ENV}=$true # true or false



# end

# You can overwrite this file in .env.ps1

$CI_HOST="ci.khs1994.com:1218"

# wsl name
# $ wslconfig /l
# $ wsl -l
$DistributionName="Ubuntu-22.04"

# latest php version
$LNMP_PHP_IMAGE="khs1994/php:8.3.0-composer-alpine"

$NGINX_PATH="C:/nginx"
$PHP_PATH="C:/php"

# used by $ lnmp-wnamp start common
$COMMON_SOFT="nginx","php","mysql","wsl-redis"

$LNMP_NODE_IMAGE="node:alpine"
# $LNMP_NODE_IMAGE="khs1994/node:git"

# $LNMP_CACHE=

# 挂载物理硬盘到 WSL2
# $ wmic diskdrive list brief
# $MountPhysicalDiskDeviceID2WSL2="\\.\PHYSICALDRIVE0"
# $MountPhysicalDiskPartitions2WSL2="3"
# $MountPhysicalDiskType2WSL2="ext4"
