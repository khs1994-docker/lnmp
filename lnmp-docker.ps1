. .env.ps1

Function init{
  #.env
  if (Test-Path .env){
    Write-Host .env file existing
  }else{
    cp .env.example .env
  }
  # logs file
}
Function help_information{
  echo "Docker-LNMP CLI ${KHS1994_LNMP_DOCKER_VERSION}

Usage: ./docker-lnmp COMMAND

Commands:
backup               Backup MySQL databases
cleanup              Cleanup log files
composer             Use PHP Package Management composer
development          Use LNMP in Development(Support x86_64 arm32v7 arm64v8)
development-config   Validate and view the Development(with build images) Compose file
development-build    Use LNMP in Development With Build images(Support x86_64)
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

}

Function composer($COMPOSE_PATH,$CMD){
  Write-Host $COMPOSE_PATH
  Write-Host $CMD
  Write-Host "IN khs1994/php-fpm:$KHS1994_LNMP_PHP_VERSION  /app/${COMPOSE_PATH} EXEC $ composer ${CMD}"
  docker run -it --rm -v $pwd\app\${COMPOSE_PATH}:/app/${COMPOSE_PATH} khs1994/php-fpm:$KHS1994_LNMP_PHP_VERSION composer ${CMD}
}

Function update(){
  git fetch origin
  git reset --hard origin/dev
}

Function main() {
  switch($args[0])
  {

    init {

    }

    commit {
      git add .
      git commit -m "Update [skip ci]"
      git push origin dev
    }

    backup {

    }

    cleanup {

    }

    composer {
      composer $args[1] $args[2]
    }

    development {}

    development-config{
      docker-compose -f docker-compose.yml -f docker-compose.build.yml config
    }

    development-build{
      docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d
    }

    down {

    }

    help {

    }

    laravel {

    }

    laravel-artisan {

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

    }

    mongo-cli {

    }

    mysql-cli {

    }

    nginx-cli {

    }

    php-cli {

    }

    postgres-cli {

    }

    rabbitmq-cli {

    }

    redis-cli {

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
