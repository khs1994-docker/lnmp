#
# https://github.com/mysql/mysql-server
#

. "$PSScriptRoot/common.ps1"

$create=$false

docker network create lnmp_backend | Out-Null

if ($?){
  $create=$true
}

docker run -it --rm `
    --network lnmp_backend `
    -e TZ=${TZ} `
    --entrypoint mysql `
    mysql:8.0.11 `
    $args

if($create){
  docker network rm lnmp_backend
}
