#
# https://github.com/mysql/mysql-server
#

. "$PSScriptROOT/../.env.example.ps1"

if (Test-Path "$PSScriptROOT/../.env.ps1"){
  . "$PSScriptROOT/../.env.ps1"
}

docker network create lnmp_backend | Out-Null

docker run -it --rm `
    -e TZ=${TZ} `
    mysql:8.0.11 `
    $args
