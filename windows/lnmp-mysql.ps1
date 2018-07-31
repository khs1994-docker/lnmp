#
# https://github.com/mysql/mysql-server
#

. "$PSScriptROOT/../.env.example.ps1"

if (Test-Path "$PSScriptROOT/../.env.ps1"){
  . "$PSScriptROOT/../.env.ps1"
}

$create=$false

docker network create lnmp_backend | Out-Null

if ($?){
  $create=$true
}

docker run -it --rm `
    -e TZ=${TZ} `
    mysql:8.0.11 `
    $args

if($create){
  docker network rm lnmp_backend
}
