#
# https://github.com/travis-ci/travis.rb#readme
#

docker run -it --rm `
    --mount type=bind,source=$PWD,target=/app `
    -e GITHUB_TOKEN=$env:GITHUB_TOKEN `
    --mount source=lnmp_travis-data,target=/root/.travis `
    khs1994/travis:cli `
    $args
