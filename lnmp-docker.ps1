. .env.ps1

Function env_status(){
  if (Test-Path .env){
    Write-Host .env file existing
  }else{
    Write-Host .env file NOT existing
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
  Write-Host "Init is SUCCESS"
}

Function help_information(){
  echo "Docker-LNMP CLI ${KHS1994_LNMP_DOCKER_VERSION}

Usage: ./docker-lnmp.ps1 COMMAND

Commands:
backup               Backup MySQL databases
cleanup              Cleanup log files
composer             Use PHP Package Management composer
development          Use LNMP in Development
development-config   Validate and view the Development(with build images)Compose file
development-build    Use LNMP in Development With Build images
down                 Stop and remove LNMP Docker containers, networks, images, and volumes
help                 Display this help message
laravel              Create a new Laravel application
laravel-artisan      Use Laravel CLI artisan
mysql-demo           Create MySQL test database
php                  Run PHP in CLI
push                 Build and Pushes images to Docker Registory v2
restore              Restore MySQL databases

Container CLI:
memcached-cli
mongo-cli
mysql-cli
nginx-cli
php-cli
postgres-cli
rabbitmq-cli
redis-cli

Tools:
update                Upgrades LNMP

Read './docs/*.md' for more information about commands."
}

Function backup(){

}

Function cleanup(){
  Write-Host " " | Out
}

Function composer($COMPOSE_PATH,$CMD){
  Write-Host "IN khs1994/php-fpm:$KHS1994_LNMP_PHP_VERSION  /app/${COMPOSE_PATH} EXEC $ composer ${CMD}"
  Write-Host "output information"
  Write-Host " "
  docker run -it --rm -v $pwd\app\${COMPOSE_PATH}:/app -v $pwd\tmp\cache:/tmp/cache khs1994/php-fpm:$KHS1994_LNMP_PHP_VERSION composer ${CMD}
}

Function laravel($LARAVEL_PATH){
  Write-Host "IN khs1994/php-fpm:$KHS1994_LNMP_PHP_VERSION  /app/ EXEC $ laravel new ${LARAVEL_PATH}"
  Write-Host "output information"
  Write-Host " "
  docker run -it --rm -v $pwd\app:/app -v $pwd\tmp\cache:/tmp/cache khs1994/php-fpm:$KHS1994_LNMP_PHP_VERSION laravel new ${LARAVEL_PATH}
}

Function laravel-artisan($LARAVEL_PATH,$CMD){
  Write-Host "IN khs1994/php-fpm:$KHS1994_LNMP_PHP_VERSION  /app/${LARAVEL_PATH} EXEC $ php artisan ${CMD}"
  Write-Host "output information"
  Write-Host " "
  docker run -it --rm -v $pwd\app\${LARAVEL_PATH}:/app khs1994/php-fpm:$KHS1994_LNMP_PHP_VERSION php artisan ${CMD}
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
      Write-Host "Branch is ${BRANCH}"
      Write-Host " "
      if (${BRANCH} -eq "dev"){
        git add .
        git commit -m "Update [skip ci]"
        git push origin dev
      }else{
        Write-Host "NOT Support ${BRANCH} branch"
      }
    }

    backup {

    }

    cleanup {

    }

    composer {
      composer $args[1] $args[2]
    }

    development {
      init
      docker-compose up -d
    }

    development-config{
      docker-compose -f docker-compose.yml -f docker-compose.build.yml config
    }

    development-build{
      docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d
    }

    down {
      docker-compose down
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

    mysql-demo {

    }

    php {

    }

    push {

    }

    restore {

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

    default {
      help_information
    }
  }
}

main $args[0] $args[1] $args[2] $args[3] $args[4] $args[5]
