$global:KHS1994_LNMP_DOCKER_VERSION="v18.06"
$global:KHS1994_LNMP_PHP_VERSION="7.2.4"
$global:DEVELOPMENT_INCLUDE='nginx','mysql','php7','redis','phpmyadmin'

$source=$pwd

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

if (!(Test-Path cli/khs1994-robot.enc )){

  # 在项目目录外
  if ($env:LNMP_PATH.Length -eq 0){
  # 没有设置系统环境变量，则退出
    printWarning "Please set system environment, more information please see bin/README.md"

    exit 1
  }else{
    # 设置了系统环境变量

    printInfo "Use LNMP CLI in $PWD"
    cd $env:LNMP_PATH
  }

}else {
  printInfo "Use LNMP CLI in LNMP Root $pwd"
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

ClusterKit
  clusterkit [-d]              UP LNMP With Mysql Redis Memcached Cluster [Background]

  clusterkit-mysql-up          Up MySQL Cluster
  clusterkit-mysql-down        Stop MySQL Cluster
  clusterkit-mysql-exec        Execute a command in a running MySQL Cluster node

  clusterkit-memcached-up      Up memcached Cluster
  clusterkit-memcached-down    Stop memcached Cluster
  clusterkit-memcached-exec    Execute a command in a running memcached Cluster node

  clusterkit-redis-up          Up Redis Cluster
  clusterkit-redis-down        Stop Redis Cluster
  clusterkit-redis-exec        Execute a command in a running Redis Cluster node

  clusterkit-redis-master-slave-up       Up Redis M-S
  clusterkit-redis-master-slave-down     Stop Redis M-S
  clusterkit-redis-master-slave-exec     Execute a command in a running Redis M-S node

  clusterkit-redis-sentinel-up           Up Redis S
  clusterkit-redis-sentinel-down         Stop Redis S
  clusterkit-redis-sentinel-exec         Execute a command in a running Redis S node

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

cd $source

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
  git remote rm origin
  git remote add origin git@github.com:khs1994-docker/lnmp
  git fetch origin
  ${BRANCH}=(git rev-parse --abbrev-ref HEAD)
  if (${BRANCH} -eq "dev"){
    git reset --hard origin/dev
    git submodule update --init --recursive
  }elseif(${BRANCH} -eq "master"){
    git reset --hard origin/master
    git submodule update --init --recursive
  }else{
    git checkout dev
    git reset --hard origin/dev
    git submodule update --init --recursive
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

Function clusterkit_bash_cli($env, $service, $command){
  docker exec -it `
    $( docker container ls `
        --format "{{.ID}}" `
        -f label=com.khs1994.lnmp `
        -f label=com.khs1994.lnmp.app.env=$env `
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
      docker-compose up -d ${DEVELOPMENT_INCLUDE}
    }

    development-pull {
      docker-compose pull ${DEVELOPMENT_INCLUDE}
    }

    down {
      docker-compose down --remove-orphans
    }

    docs {
      docker run --init -it --rm -p 4000:4000 --mount type=bind,src=$pwd\docs,target=/srv/gitbook-src khs1994/gitbook server
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

    clusterkit {
       docker-compose -f docker-compose.yml \
         -f docker-compose.override.yml \
         -f docker-cluster.mysql.yml \
         -f docker-cluster.redis.yml \
         up $other
    }

    clusterkit-mysql-up {
       docker-compose -f docker-cluster.mysql.yml up $other
    }

    clusterkit-mysql-down {
       docker-compose -f docker-cluster.mysql.yml down $other
    }

    clusterkit-mysql-exec {
         $service,$cmd=$other
         if ($cmd.Count -eq 0){
           echo '$ ./lnmp-docker.ps1 clusterkit-mysql-exec {master|node-N} {COMMAND}'

           cd $source

           exit 1
         }
         clusterkit_bash_cli clusterkit_mysql mysql_$service $cmd
    }

    clusterkit-memcached-up {
      docker-compose -f docker-cluster.memcached.yml up $other
    }

    clusterkit-memcached-down {
      docker-compose -f docker-cluster.memcached.yml down $other
    }

    clusterkit-memcached-exec {
      $service,$cmd=$other
      if ($cmd.Count -eq 0){
        echo '$ ./lnmp-docker.ps1 clusterkit-memcached-exec {N} {COMMAND}'

        cd $source

        exit 1
      }
      clusterkit_bash_cli clusterkit_memcached memcached-$service $cmd
    }

    clusterkit-redis-up {
          docker-compose -f docker-cluster.redis.yml up $other
    }

    clusterkit-redis-down {
          docker-compose -f docker-cluster.redis.yml down $other
    }

    clusterkit-redis-exec {
      $service,$cmd=$other
      if ($cmd.Count -eq 0){
        echo '$ ./lnmp-docker.ps1 clusterkit-redis-exec {master-N|slave-N} {COMMAND}'

        cd $source

        exit 1
      }
      clusterkit_bash_cli clusterkit_redis redis_$service $cmd
    }

    clusterkit-redis-master-slave-up {
          docker-compose -f docker-cluster.redis.master.slave.yml up $other
    }

    clusterkit-redis-master-slave-down {
          docker-compose -f docker-cluster.redis.master.slave.yml down $other
    }

    clusterkit-redis-master-slave-exec {
      $service,$cmd=$other
      if ($cmd.Count -eq 0){
        echo '$ ./lnmp-docker.ps1 clusterkit-redis-master-slave-exec {master|slave-N} {COMMAND}'

        cd $source

        exit 1
      }
      clusterkit_bash_cli clusterkit_redis_master_slave redis_m_s_$service $cmd
    }

    clusterkit-redis-sentinel-up {
          docker-compose -f docker-cluster.redis.sentinel.yml up $other
    }

    clusterkit-redis-sentinel-down {
          docker-compose -f docker-cluster.redis.sentinel.yml down $other
    }

    clusterkit-redis-sentinel-exec {
      $service,$cmd=$other
      if ($cmd.Count -eq 0){
        echo '$ ./lnmp-docker.ps1 clusterkit-redis-sentinel-exec {master-N|slave-N|sentinel-N} {COMMAND}'

        cd $source

        exit 1
      }
      clusterkit_bash_cli clusterkit_redis_sentinel redis_sentinel_$service $cmd
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

cd $source
