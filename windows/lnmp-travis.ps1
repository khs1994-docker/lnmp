#
# https://github.com/travis-ci/travis.rb#readme
#

. "$PSScriptRoot/common.ps1"

if ( $env:GITHUB_TOKEN.length -eq 0 ){
  echo "You must set [ GITHUB_TOKEN ] env"
  write-host
  echo '$ [environment]::SetEnvironmentvariable("GITHUB_TOKEN", "XXXX...", "User");'
  write-host
  exit 1
}

docker run -it --rm `
    --mount type=bind,source=$PWD,target=/app `
    -e GITHUB_TOKEN=$env:GITHUB_TOKEN `
    --mount source=lnmp_travis-data,target=/root/.travis `
    khs1994/travis:cli `
    $args
