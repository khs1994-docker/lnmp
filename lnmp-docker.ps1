$global:KHS1994_LNMP_DOCKER_VERSION="v18.03-rc1"
$global:KHS1994_LNMP_PHP_VERSION="7.2.2"

Function printError(){
Write-Host " "
Write-Host 'Error   ' -NoNewLine -ForegroundColor Red
Write-Host "$args";
Write-Host " "
}

Function printInfo(){
Write-Host " "
Write-Host 'INFO    ' -NoNewLine -ForegroundColor Green
Write-Host "$args";
Write-Host " "
}

Function printWarning(){
Write-Host " "
Write-Host 'Warning  ' -NoNewLine -ForegroundColor Red
Write-Host "$args";
Write-Host " "
}

Function env_status(){
  if (Test-Path .env){
    printInfo '.env file existing'
  }else{
    printWarning '.env file NOT existing'
    cp .env.example .env
  }
}

Function logs(){
  if (! (Test-Path logs\apache2)){
    New-Item logs\apache2 -type directory | Out-Null
  }
  if (! (Test-Path logs\mongodb)){
    New-Item logs\mongodb -type directory | Out-Null
    New-Item logs\mongodb\mongo.log -type file | Out-Null
  }
  if (-not (Test-Path logs\mysql)){
    New-Item logs\mysql -type directory | Out-Null
    New-Item logs\mysql\error.log -type file | Out-Null
  }
  if (-not (Test-Path logs\mariadb)){
    New-Item logs\mariadb -type directory | Out-Null
    New-Item logs\mariadb\error.log -type file | Out-Null
  }
  if (! (Test-Path logs\nginx)){
    New-Item logs\nginx -type directory | Out-Null
    New-Item logs\nginx\access.log -type file | Out-Null
    New-Item logs\nginx\error.log -type file | Out-Null
  }
  if (! (Test-Path logs\php-fpm)){
    New-Item logs\php-fpm -type directory | Out-Null
    New-Item logs\php-fpm\error.log -type file | Out-Null
    New-Item logs\php-fpm\access.log -type file | Out-Null
    New-Item logs\php-fpm\xdebug-remote.log -type file | Out-Null
  }
  if (! (Test-Path logs\php-fpm\php)){
    New-Item logs\php-fpm\php -type directory | Out-Null
  }
  if (! (Test-Path logs\redis)){
    New-Item logs\redis -type directory | Out-Null
    New-Item logs\redis\redis.log -type file | Out-Null
  }
  if (! (Test-Path tmp\cache)){
    New-Item tmp\cache -type directory | Out-Null
  }
}

Function init(){
  docker-compose --version
  logs
  git submodule update --init --recursive
  printInfo 'Init is SUCCESS'
}

Function help_information(){
  echo "Docker-LNMP CLI ${KHS1994_LNMP_DOCKER_VERSION}

Official WebSite https://lnmp.khs1994.com

Usage: ./docker-lnmp.sh COMMAND

Commands:
  backup               Backup MySQL databases
  build                Use LNMP With Build images(Support x86_64)
  build-config         Validate and view the build images Compose file
  cleanup              Cleanup log files
  config               Validate and view the Development Compose file
  development          Use LNMP in Development(Support x86_64 arm32v7 arm64v8)
  development-pull     Pull LNMP Docker Images in development
  down                 Stop and remove LNMP Docker containers, networks, images, and volumes
  docs                 Support Documents
  full-up              Start Soft you inout, all soft available
  help                 Display this help message
  init                 Init LNMP environment
  k8s                  Deploy LNMP on k8s
  k8s-build            Build LNMP on k8s image (nginx php7)
  k8s-down             Remove LNMP on k8s
  k8s-push             Push LNMP on k8s image (nginx php7)
  production-config    Validate and view the Production Compose file
  push                 Build and Pushes images to Docker Registory v2
  restore              Restore MySQL databases
  restart              Restart LNMP services
  ssl-self             Issue Self-signed SSL certificate

PHP Tools:
  apache-config        Generate Apache2 vhost conf
  composer             Use PHP Dependency Manager Composer
  laravel              Create a new Laravel application
  laravel-artisan      Use Laravel CLI artisan
  new                  New PHP Project and generate nginx conf and issue SSL certificate
  nginx-config         Generate nginx vhost conf
  php                  Run PHP in CLI
  phpunit              Run PHPUnit
  ssl-self             Issue Self-signed SSL certificate
  tp                   Create a new ThinkPHP application


Container CLI:
  apache-cli
  mariadb-cli
  memcached-cli
  mongo-cli
  mysql-cli
  nginx-cli
  php-cli
  postgres-cli
  rabbitmq-cli
  redis-cli

Tools:
  update               Upgrades LNMP
  upgrade              Upgrades LNMP

Read './docs/*.md' for more information about commands.

You can open issue in [ https://github.com/khs1994-docker/lnmp/issues ] when you meet problems.

You must Update .env file when update this project.

Donate https://zan.khs1994.com"
exit
}

Function cleanup(){
  Write-Host " "
  logs
  rm logs\apache2 -Recurse -Force | Out-Null
  rm logs\mongodb -Recurse -Force | Out-Null
  rm logs\mysql -Recurse -Force | Out-Null
  rm logs\mariadb -Recurse -Force | Out-Null
  rm logs\nginx -Recurse -Force | Out-Null
  rm logs\php-fpm -Recurse -Force | Out-Null
  rm logs\redis -Recurse -Force | Out-Null
  logs

  printInfo "Cleanup logs files Success"
}

Function _composer($COMPOSE_PATH,$CMD){
  printInfo "IN khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7  /app/${COMPOSE_PATH} EXEC $ composer ${CMD}"
  printInfo 'output information'
  docker run -it --rm --mount type=bind,src=$pwd/app/${COMPOSE_PATH},target=/app --mount type=bind,src=$pwd/tmp/cache,target=/tmp/cache khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7 composer ${CMD}
}

Function _laravel($LARAVEL_PATH){
  printInfo "IN khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7  /app/ EXEC $ laravel new ${LARAVEL_PATH}"
  printInfo 'output information'
  docker run -it --rm --mount type=bind,src=$pwd/app,target=/app -v $pwd/tmp/cache:/tmp/cache khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7 laravel new ${LARAVEL_PATH}
}

Function laravel-artisan($LARAVEL_PATH,$CMD){
  printInfo "IN khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7  /app/${LARAVEL_PATH} EXEC $ php artisan ${CMD}"
  printInfo 'output information'
  docker run -it --rm --mount type=bind,src=$pwd\app\${LARAVEL_PATH},target=/app khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7 php artisan ${CMD}
}

Function _update(){
  git remote rm lnmp
  git remote add lnmp git@github.com:khs1994-docker/lnmp
  git fetch lnmp
  ${BRANCH}=(git rev-parse --abbrev-ref HEAD)
  if (${BRANCH} -eq "dev"){
    git submodule update --init --recursive
    git reset --hard lnmp/dev
  }elseif(${BRANCH} -eq "master"){
    git submodule update --init --recursive
    git reset --hard lnmp/master
  }else{
    git checkout dev
    git reset --hard lnmp/dev
  }
}

# main

env_status

if ($args.Count -eq 0){
  help_information
}else{
  $first, $other = $args
}

switch($first){

    init {
      init
    }

    apache-config {
      printInfo "TODO"
    }

    backup {
        docker-compose exec mysql /backup/backup.sh $other
    }

    build {
      docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d
    }

    build-config {
      docker-compose -f docker-compose.yml -f docker-compose.build.yml config
    }

    cleanup {
      cleanup
    }

    config {
      docker-compose config
    }

    composer {
      $path,$other=$other
      _composer $path $other
    }

    development {
      init
      docker-compose up -d
    }

    development-pull {
      docker-compose pull
    }

    down {
      docker-compose down --remove-orphans
    }

    docs {
      docker run -it --rm -p 4000:4000 --mount type=bind,src=$pwd\docs,target=/srv/gitbook-src khs1994/gitbook server
    }

    full-up {
      docker-compose -f docker-full.yml -f docker-compose.override.yml up -d $other
    }

    k8s {
      cd kubernetes
      # kubectl create -f lnmp-volumes.yaml
      kubectl create -f lnmp-env.yaml
      kubectl create secret generic lnmp-mysql-password --from-literal=password=mytest
      kubectl create -f lnmp-mysql.yaml
      kubectl create -f lnmp-redis.yaml
      kubectl create -f lnmp-php7.yaml
      kubectl create -f lnmp-nginx.yaml
      cd ..
    }

    k8s-down {
      cd kubernetes
      kubectl delete deployment -l app=lnmp
      kubectl delete service -l app=lnmp
      kubectl delete pvc -l app=lnmp
      kubectl delete pv lnmp-mysql-data lnmp-redis-data
      kubectl delete secret lnmp-mysql-password
      kubectl delete configmap lnmp-env
      cd ..
    }

    k8s-build {
      docker-compose -f docker-stack.yml build
    }

    k8s-push {
      docker-compose -f docker-stack.yml push nginx php7
    }

    laravel {
      _laravel $other
    }

    laravel-artisan {
      $path,$other=$other
      laravel-artisan $path $other
    }

    new {
      printInfo "TODO"
    }

    nginx-config {
      printInfo "TODO"
    }

    php {
      if ($other.Count -lt 2){
        printError "

Usage:

./lnmp-docker.ps1 php {PATH} [options] [-f] <file> [--] [args...]
./lnmp-docker.ps1 php {PATH} [options] -r <code> [--] [args...]
./lnmp-docker.ps1 php {PATH} [options] [-B <begin_code>] -R <code> [-E <end_code>] [--] [args...]
./lnmp-docker.ps1 php {PATH} [options] [-B <begin_code>] -F <file> [-E <end_code>] [--] [args...]
./lnmp-docker.ps1 php {PATH} [options] -S <addr>:<port> [-t docroot] [router]
./lnmp-docker.ps1 php {PATH) [options] -- [args...]
./lnmp-docker.ps1 php {PATH) [options] -a
"
        exit
      }

      $PHP_PATH,$other=$other
      printInfo "IN khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7  /app/${PHP_PATH} EXEC $ php $other"


      docker run -it --rm --mount type=bind,src=$pwd/app/${PHP_PATH},target=/app khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7 php $other
    }

    phpunit {
      if ($other.Count -lt 1){
        printError "

Usage:

./lnmp-docker.ps1 phpunit {PATH} [options] UnitTest [UnitTest.php]
./lnmp-docker.ps1 phpunit {PATH} [options] <directory>"
        exit
      }

      $PHPUNIT_PATH,$other=$other
      printInfo "IN khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7  /app/${PHPUNIT_PATH} EXEC $ vendor/bin/phpunit ${other}"

      docker run -it --rm --mount type=bind,src=$pwd/app/${PHPUnit_PATH},target=/app khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7 vendor/bin/phpunit $other
    }

    production-config {
       docker-compose -f docker-compose.yml -f docker-compose.prod.yml config
    }

    push {
      docker-compose -f docker-compose.yml -f docker-compose.build.yml build
      docker-compose -f docker-compose.yml -f docker-compose.build.yml push
    }

    restore {
       docker-compose exec mysql /backup/restore.sh $other
    }

    restart {
      docker-compose restart $other
    }

    ssl-self {
      docker run -it --rm -v $pwd/config/nginx/ssl-self:/ssl khs1994/tls $other
      printInfo 'Import ./config/nginx/ssl-self/root-ca.crt to Browsers,then set hosts in C:\Windows\System32\drivers\etc\hosts'
    }

    tp {
      $TP_PATH,$other=$other
      _composer "" create-project,topthink/think=5.0.*,${TP_PATH},--prefer-dist,$other
    }

    tz {
      docker run -it --rm --mount src=lnmp_zoneinfo-data,target=/usr/share/zoneinfo alpine:3.7 apk add --no-cache tzdata
    }

    apache-cli {
      docker-compose exec apache sh
    }

    memcached-cli {
      docker-compose exec memcached sh
    }

    mongo-cli {
      docker-compose exec mongodb bash
    }

    mysql-cli {
      docker-compose exec mysql bash
    }

    mariadb-cli {
      docker-compose exec mariadb bash
    }

    nginx-cli {
      docker-compose exec nginx sh
    }

    php-cli {
      docker-compose exec php7 bash
    }

    postgres-cli {
      docker-compose exec postgresql sh
    }

    rabbitmq-cli {
       docker-compose exec rabbitmq sh
    }

    redis-cli {
      docker-compose exec redis sh
    }

    {$_ -in "update","upgrade"} {
      _update
    }

    {$_ -in "-h","--help","help"} {
      help_information
    }

    default {
        printInfo "You Exec docker-compose command, maybe you input command is notdefined, then output docker-compose help information"
        docker-compose $args
      }
}
