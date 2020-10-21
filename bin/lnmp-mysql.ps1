#
# https://github.com/mysql/mysql-server
#

. "$PSScriptRoot/common.ps1"

$NETWORK="lnmp_backend"
if ($null -eq $(docker network ls -f name="lnmp_backend" -q)){
  $NETWORK="bridge"
}

docker run -it --rm `
    --network $NETWORK `
    -e TZ=${TZ} `
    --entrypoint mysql `
    mysql:8.0.22 `
    $args
