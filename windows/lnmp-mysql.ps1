#
# https://github.com/mysql/mysql-server
#

docker network create lnmp_backend | Out-Null

docker run -it --rm `
    mysql:8.0.3 `
    $args
