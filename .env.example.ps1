# You can overwrite this file in .env.ps1

$CI_HOST="ci.khs1994.com:1218"

# wsl name
# $ wslconfig /l
# $ wsl -l
$DistributionName="Ubuntu-22.04"

$LNMP_PHP_IMAGE="khs1994/php:8.2.3-composer-alpine"

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
