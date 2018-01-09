$global:KHS1994_LNMP_DOCKER_VERSION="v18.01-rc2"
$global:KHS1994_LNMP_PHP_VERSION="7.2.1"

Function printError(){
Write-Host " "
Write-Host 'Error   ' -NoNewLine -ForegroundColor Red
Write-Host $args['0'];
Write-Host " "
}

Function printInfo(){
Write-Host " "
Write-Host 'INFO    ' -NoNewLine -ForegroundColor Green
Write-Host $args['0'];
Write-Host " "
}

Function printWarning(){
Write-Host " "
Write-Host 'Warning  ' -NoNewLine -ForegroundColor Red
Write-Host $args['0'];
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
  if (! (Test-Path logs\mongodb)){
    New-Item logs\mongodb -type directory | Out-Null
    New-Item logs\mongodb\mongo.log -type file | Out-Null
  }
  if (-not (Test-Path logs\mysql)){
    New-Item logs\mysql -type directory | Out-Null
    New-Item logs\mysql\error.log -type file | Out-Null
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
  composer             Use PHP Package Management composer
  config               Validate and view the Development Compose file
  development          Use LNMP in Development(Support x86_64 arm32v7 arm64v8)
  down                 Stop and remove LNMP Docker containers, networks, images, and volumes
  docs                 Support Documents
  help                 Display this help message
  init                 Init LNMP environment
  laravel              Create a new Laravel application
  laravel-artisan      Use Laravel CLI artisan
  new                  New PHP Project and generate nginx conf and issue SSL certificate
  php                  Run PHP in CLI
  production           Use LNMP in Production(Only Support Linux x86_64)
  production-config    Validate and view the Production Compose file
  push                 Build and Pushes images to Docker Registory v2
  restore              Restore MySQL databases
  ssl                  Issue SSL certificate powered by acme.sh
  ssl-self             Issue Self-signed SSL certificate
  swarm-build          Build Swarm image (nginx php7)
  swarm-push           Push Swarm image (nginx php7)
  swarm-deploy         Deploy LNMP stack TO Swarm mode
  swarm-down           Remove LNMP stack IN Swarm mode

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
  commit
  cn-mirror            Push master branch to CN mirror
  update               Upgrades LNMP
  upgrade              Upgrades LNMP

Read './docs/*.md' for more information about commands."
}

Function backup(){
  docker-compose exec mysql /backup/backup.sh $args[1] $args[2] $args[3]
}

Function cleanup(){
  Write-Host " "
  rm logs\mongodb -Recurse -Force
  rm logs\mysql -Recurse -Force
  rm logs\nginx -Recurse -Force
  rm logs\php-fpm -Recurse -Force
  rm logs\redis -Recurse -Force
  logs
}

Function composer($COMPOSE_PATH,$CMD){
  printInfo "IN khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7  /app/${COMPOSE_PATH} EXEC $ composer ${CMD}"
  printInfo 'output information'
  docker run -it --rm -v $pwd\app\${COMPOSE_PATH}:/app -v $pwd\tmp\cache:/tmp/cache khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7 composer ${CMD}
}

Function laravel($LARAVEL_PATH){
  printInfo "IN khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7  /app/ EXEC $ laravel new ${LARAVEL_PATH}"
  printInfo 'output information'
  docker run -it --rm -v $pwd\app:/app -v $pwd\tmp\cache:/tmp/cache khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7 laravel new ${LARAVEL_PATH}
}

Function laravel-artisan($LARAVEL_PATH,$CMD){
  printInfo "IN khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7  /app/${LARAVEL_PATH} EXEC $ php artisan ${CMD}"
  printInfo 'output information'
  docker run -it --rm -v $pwd\app\${LARAVEL_PATH}:/app khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7 php artisan ${CMD}
}

Function update(){
  git fetch origin
  ${BRANCH}=(git rev-parse --abbrev-ref HEAD)
  if (${BRANCH} -eq "dev"){
    git reset --hard origin/dev
  }elseif(${BRANCH} -eq "master"){
    git reset --hard origin/master
  }else{
    git checkout dev
    git reset --hard origin/dev
  }
}

Function main() {
  env_status
  switch($args[0])
  {

    init {
      init
    }

    commit {
      ${BRANCH}=(git rev-parse --abbrev-ref HEAD)
      printInfo "Branch is ${BRANCH}"
      if (${BRANCH} -eq "dev"){
        git add .
        git commit -m "Update [skip ci]"
        git push origin dev
      }else{
        printError "NOT Support ${BRANCH} branch"
      }
    }

    config {
      docker-compose config
    }

    backup {
      backup
    }

    cleanup {
      cleanup
    }

    composer {
      composer $args[1] $args[2]
    }

    development {
      init
      docker-compose up -d
    }

    build-config{
      docker-compose -f docker-compose.yml -f docker-compose.build.yml config
    }

    build{
      docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d
    }

    push {
      docker-compose -f docker-compose.yml -f docker-compose.build.yml build
      docker-compose -f docker-compose.yml -f docker-compose.build.yml push
    }

    down {
      docker-compose down
    }

    docs {
      docker run -it --rm -p 4000:4000 -v $pwd\docs:/srv/gitbook-src khs1994/gitbook server
    }

    help {
      help_information
    }

    laravel {
      laravel $args[1]
    }

    laravel-artisan {
      laravel-artisan $args[1] $args[2]
    }

    php {
      $PHP_PATH=$args[1]
      $PHP_FILE=$args[2]
      docker run -it --rm -v $pwd\app\${PHP_PATH}:/app khs1994/php-fpm:${KHS1994_LNMP_PHP_VERSION}-alpine3.7 php $PHP_FILE
    }

    production-config {
       docker-compose -f docker-compose.yml -f docker-compose.prod.yml config
    }

    restore {
       docker-compose exec mysql /backup/restore.sh $args[1]
    }

    ssl-self {
      $DOMAIN=$args[1]
      docker run -it --rm -v $pwd\config\nginx\ssl-self:/ssl khs1994/tls $DOMAIN
      printInfo 'Please set hosts in C:\Windows\System32\drivers\etc\hosts'
    }

    swarm-build {
      docker-compose -f docker-stack.yml build
    }

    swarm-push {
      docker-compose -f docker-stack.yml push nginx php7
    }

    swarm-deploy {
      docker stack deploy -c docker-stack.yml lnmp
    }

    swarm-down {
      docker stack rm lnmp
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

    update{
      update
    }

    upgrade {
      update
    }

    default {
      help_information
    }
  }
}

main $args[0] $args[1] $args[2] $args[3] $args[4] $args[5]
