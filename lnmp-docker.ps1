$global:KHS1994_LNMP_DOCKER_VERSION="v18.05-rc2"
$global:KHS1994_LNMP_PHP_VERSION="7.2.3"

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
  if (! (Test-Path logs\httpd)){
    New-Item logs\httpd -type directory | Out-Null
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
  if (! (Test-Path logs\redis)){
    New-Item logs\redis -type directory | Out-Null
    New-Item logs\redis\redis.log -type file | Out-Null
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
  build                Build or rebuild LNMP Self Build images (Only Support x86_64)
  build-config         Validate and view the LNMP Self Build images Compose file
  build-up             Create and start LNMP containers With Self Build images (Only Support x86_64)
  build-push           Build and Pushes images to Docker Registory
  cleanup              Cleanup log files
  development          Use LNMP in Development(Support x86_64 arm32v7 arm64v8)
  development-config   Validate and view the Development Compose file
  development-pull     Pull LNMP Docker Images in development
  down                 Stop and remove LNMP Docker containers, networks, images, and volumes
  docs                 Support Documents
  full-up              Start Soft you input, all soft available
  help                 Display this help message
  init                 Init LNMP environment
  restore              Restore MySQL databases
  restart              Restart LNMP services

PHP Tools:
  httpd-config        Generate Apache2 vhost conf
  new                  New PHP Project and generate nginx conf and issue SSL certificate
  nginx-config         Generate nginx vhost conf
  ssl-self             Issue Self-signed SSL certificate
  tp                   Create a new ThinkPHP application

Kubernets:
  dashboard            Print how run kubernetes dashboard in Dcoekr for Desktop

Swarm mode:
  swarm-build          Build Swarm image (nginx php7)
  swarm-config         Validate and view the Production Swarm mode Compose file
  swarm-push           Push Swarm image (nginx php7)

Container CLI:
  SERVICE-cli          Execute a command in a running LNMP container

LogKit:
  SERVICE-logs         Print LNMP containers logs (journald)

Developer Tools:
  update               Upgrades LNMP
  upgrade              Upgrades LNMP

Read './docs/*.md' for more information about CLI commands.

You can open issue in [ https://github.com/khs1994-docker/lnmp/issues ] when you meet problems.

You must Update .env file when update this project.

Donate https://zan.khs1994.com"
exit
}

Function cleanup(){
  Write-Host " "
  logs
  rm logs\httpd -Recurse -Force | Out-Null
  rm logs\mongodb -Recurse -Force | Out-Null
  rm logs\mysql -Recurse -Force | Out-Null
  rm logs\mariadb -Recurse -Force | Out-Null
  rm logs\nginx -Recurse -Force | Out-Null
  rm logs\php-fpm -Recurse -Force | Out-Null
  rm logs\redis -Recurse -Force | Out-Null
  logs

  printInfo "Cleanup logs files Success"
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

Function _bash_cli($service, $command){
  docker exec -it `
      $(docker container ls `
          --format "{{.ID}}" `
          -f label=com.khs1994.lnmp `
          -f label=com.docker.compose.service=$service -n 1 ) `
          $command
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

    httpd-config {
      bash lnmp-docker.sh httpd-config $other
    }

    backup {
        docker-compose exec mysql /backup/backup.sh $other
    }

    build {
      docker-compose -f docker-compose.yml -f docker-compose.build.yml build $other
    }

    build-config {
      docker-compose -f docker-compose.yml -f docker-compose.build.yml config
    }

    build-up {
      docker-compose -f docker-compose.yml -f docker-compose.build.yml up -d $other
    }

    cleanup {
      cleanup
    }

    config {
      docker-compose config
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
      docker run --init -it --rm -p 4000:4000 --mount type=bind,src=$pwd\docs,target=/srv/gitbook-src khs1994/gitbook server
    }

    full-up {
      docker-compose -f docker-full.yml -f docker-compose.override.yml up -d $other
    }

    dashboard {
      bash lnmp-docker.sh dashboard
    }

    new {
      bash lnmp-docker.sh new $other
    }

    nginx-config {
      bash lnmp-docker.sh nginx-config $other
    }

    swarm-config {
       docker-compose -f docker-production.yml config
    }

    swarm-build {
      docker-compose -f docker-production.yml build $other
    }

    swarm-push {
      docker-compose -f docker-production.yml push $other
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
      docker run --init -it --rm -v $pwd/config/nginx/ssl-self:/ssl khs1994/tls $other
      printInfo 'Import ./config/nginx/ssl-self/root-ca.crt to Browsers,then set hosts in C:\Windows\System32\drivers\etc\hosts'
    }

    tp {
      $TP_PATH,$other=$other
      _composer "" create-project,topthink/think=5.0.*,${TP_PATH},--prefer-dist,$other
    }

    httpd-cli {
      _bash_cli httpd sh
    }

    memcached-cli {
      _bash_cli memcached sh
    }

    mongodb-cli {
      _bash_cli mongodb bash
    }

    mysql-cli {
      _bash_cli mysql bash
    }

    mariadb-cli {
      _bash_cli mariadb bash
    }

    nginx-cli {
      _bash_cli nginx sh
    }

    php-cli {
      _bash_cli php7 bash
    }

    postgresql-cli {
      _bash_cli postgresql sh
    }

    rabbitmq-cli {
       _bash_cli rabbitmq sh
    }

    redis-cli {
      _bash_cli redis sh
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
