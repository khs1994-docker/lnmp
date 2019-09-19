. "$PSScriptRoot/.env.example.ps1"

. "$PSScriptRoot/cli/.env.ps1"

if (Test-Path "$PSScriptRoot/.env.ps1"){
  . "$PSScriptRoot/.env.ps1"
}

# [environment]::SetEnvironmentvariable("DOCKER_DEFAULT_PLATFORM", "linux", "User");

$env:path=[environment]::GetEnvironmentvariable("Path","user") `
          + ';' + [environment]::GetEnvironmentvariable("Path","machine")

$DOCKER_DEFAULT_PLATFORM="linux"
$KUBERNETES_VERSION="1.14.6"
$DOCKER_DESKTOP_VERSION="2.1.2.0 (38030)"
$source=$PWD

Function _command($command){
  get-command $command -ErrorAction "SilentlyContinue"

  return $?
}

if(_command docker){
  $DOCKER_VERSION_YY=$($(docker --version).split(' ')[2].split('.')[0])
  $DOCKER_VERSION_MM=$($(docker --version).split(' ')[2].split('.')[1])
}

$outNull=$false

if ($args[0] -eq "services"){
  $outNull=$true
}

Function printError(){
  if($outNull){
    return
  }
Write-Host "`nError   " -NoNewLine -ForegroundColor Red
Write-Host "$args`n";
}

Function printInfo(){
  if($outNull){
    return
  }
Write-Host "`nINFO    " -NoNewLine -ForegroundColor Green
Write-Host "$args`n";
}

Function printWarning(){
  if($outNull){
    return
  }
Write-Host "`nWarning  " -NoNewLine -ForegroundColor Red
Write-Host "$args`n";
}

Function _cp_only_not_exists($src,$desc){
  if (!(Test-Path $desc)){
    Copy-Item $src $desc
  }
}

Function env_status(){
  if (Test-Path .env){
    printInfo '.env file existing'
  }else{
    Write-Warning '.env file NOT existing'
    cp .env.example .env
  }

  if (Test-Path .env.ps1){
    printInfo '.env.ps1 file existing'
  }else{
    Write-Warning '.env.ps1 file NOT existing'
    cp .env.example.ps1 .env.ps1
  }

  _cp_only_not_exists kubernetes/volumes/.env.example kubernetes/volumes/.env

  _cp_only_not_exists config/supervisord/supervisord.ini.example config/supervisord/supervisord.ini

  if (!(Test-Path secrets/minio/key.txt)){
    Copy-Item secrets/minio/key.example.txt secrets/minio/key.txt
    Copy-Item secrets/minio/secret.example.txt secrets/minio/secret.txt
  }

  _cp_only_not_exists docker-lnmp.include.example.yml docker-lnmp.include.yml

  _cp_only_not_exists config/php/docker-php.ini.example config/php/docker-php.ini
  _cp_only_not_exists config/php/php.development.ini config/php/php.ini

  _cp_only_not_exists config/npm/.npmrc.example config/npm/.npmrc
  _cp_only_not_exists config/npm/.env.example config/npm/.env

  _cp_only_not_exists config/yarn/.yarnrc.example config/yarn/.yarnrc
  _cp_only_not_exists config/yarn/.env.example config/yarn/.env

  _cp_only_not_exists config/composer/.env.example config/composer/.env
  _cp_only_not_exists config/composer/.env.example.ps1 config/composer/.env.ps1
  _cp_only_not_exists config/composer/config.example.json config/composer/config.json

  _cp_only_not_exists config/registry/config.example.yml config/registry/config.yml

}

Function wait_docker(){
  while ($i -lt (300)) {
  $i +=1
  get-process docker*
  get-service docker*
  docker info
  if ($? -eq 'True') {
    Write-Host "`nDocker peparation finished OK"
    break
  }
  Write-warning "Retrying in 30 seconds..."
  sleep 30
  }
}

Function logs(){
  if (! (Test-Path log\httpd)){
    New-Item log\httpd -type directory | Out-Null
  }
  if (! (Test-Path log\mongodb)){
    New-Item log\mongodb -type directory | Out-Null
    New-Item log\mongodb\mongo.log -type file | Out-Null
  }
  if (-not (Test-Path log\mysql)){
    New-Item log\mysql -type directory | Out-Null
    New-Item log\mysql\error.log -type file | Out-Null
  }
  if (-not (Test-Path log\mariadb)){
    New-Item log\mariadb -type directory | Out-Null
    New-Item log\mariadb\error.log -type file | Out-Null
  }
  if (! (Test-Path log\nginx)){
    New-Item log\nginx -type directory | Out-Null
    New-Item log\nginx\access.log -type file | Out-Null
    New-Item log\nginx\error.log -type file | Out-Null
  }
  if (! (Test-Path log\nginx-unit)){
    New-Item log\nginx-unit -type directory | Out-Null
  }
  if (! (Test-Path log\php)){
    New-Item log\php -type directory | Out-Null
    New-Item log\php\error.log -type file | Out-Null
    New-Item log\php\slow.log -type file | Out-Null
    New-Item log\php\php-fpm-error.log -type file | Out-Null
    New-Item log\php\php-fpm-access.log -type file | Out-Null
    New-Item log\php\xdebug-remote.log -type file | Out-Null
  }
  if (! (Test-Path log\redis)){
    New-Item log\redis -type directory | Out-Null
    New-Item log\redis\redis.log -type file | Out-Null
  }

  if (! (Test-Path log\supervisord)){
    New-Item log\supervisord -type directory | Out-Null
  }

  if(! (Test-Path log\supervisord.log)){
    New-Item log\supervisord.log | Out-Null
  }
}

Function check_docker_version(){
  if(!(_command git)){
    return
  }

  ${BRANCH}=(git rev-parse --abbrev-ref HEAD)

  if (!("${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}" -eq "${BRANCH}" )) {
    printWarning "Current branch ${BRANCH} incompatible with your docker version, please checkout ${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM} branch by exec $ ./lnmp-docker checkout"
  }
}

Function init(){
  printInfo $(docker-compose --version)
  logs
  # git submodule update --init --recursive
  printInfo 'Init is SUCCESS'
  #@custom
  __lnmp_custom_init
}

Function help_information(){
  "Docker-LNMP CLI ${LNMP_DOCKER_VERSION}

Official WebSite https://lnmp.khs1994.com

Usage: ./docker-lnmp COMMAND

Try Kubernetes Free:
  k8s                  Try Kubernetes Free

Donate:
  zan                  Donate

PCIT EE:
  pcit-up              Up(Run) PCIT EE https://github.com/pcit-ce/pcit

Commands:
  up                   Up LNMP (Support x86_64 arm32v7 arm64v8)
  down                 Stop and remove LNMP Docker containers, networks, images, and volumes
  backup               Backup MySQL databases
  build                Build or rebuild LNMP Self Build images (Only Support x86_64)
  build-config         Validate and view the LNMP Self Build images Compose file
  build-up             Create and start LNMP containers With Self Build images (Only Support x86_64)
  build-push           Build and Pushes images to Docker Registory (Only Support x86_64)
  cleanup              Cleanup log files
  config               Validate and view the LNMP Compose file
  composer             Exec composer command on Docker
  bug                  Generate Debug information, then copy it to GitHub Issues
  daemon-socket        Expose Docker daemon on tcp://0.0.0.0:2376 without TLS
  env                  Edit .env/.env.ps1 file
  help                 Display this help message
  pull                 Pull LNMP Docker Images
  restore              Restore MySQL databases
  restart              Restart LNMP services
  services             List services
  update               Upgrades LNMP
  upgrade              Upgrades LNMP
  update-version       Update LNMP soft to latest vesion

lrew(package):
  init                 Init a new lrew package
  add                  Add new lrew package
  outdated             Shows a list of installed lrew packages that have updates available
  lrew-backup          Upload composer.json to GitHub Gist
  lrew-update          Update lrew package

PHP Tools:
  httpd-config         Generate Apache2 vhost conf
  new                  New PHP Project and generate nginx conf and issue SSL certificate
  nginx-config         Generate nginx vhost conf
  ssl-self             Issue Self-signed SSL certificate

Composer:
  satis                Build Satis

Kubernets:
  gcr.io               Up local gcr.io registry server to start Docker Desktop Kubernetes

Swarm mode:
  swarm-build          Build Swarm image (nginx php7)
  swarm-config         Validate and view the Production Swarm mode Compose file
  swarm-push           Push Swarm image (nginx php7)

Container Tools:
  SERVICE-cli          Execute a command in a running LNMP container

ClusterKit:
  clusterkit-help      Print ClusterKit help info

Developer Tools:
  cookbooks            Up local cookbooks server

Read './docs/*.md' for more information about CLI commands.

You can open issue in [ https://github.com/khs1994-docker/lnmp/issues ] when you meet problems.

You must Update .env file when update this project.

Exec '$ lnmp-docker k8s' Try Kubernetes Free

Exec '$ lnmp-docker zan' donate
"

cd $source

exit
}

Function clusterkit_help(){
"
ClusterKit:
  clusterkit [-d]              UP LNMP With Mysql Redis Memcached Cluster [Background]
  clusterkit-COMMAND           Run docker-compsoe commands(config, pull, etc)

  swarm-clusterkit             UP LNMP With Mysql Redis Memcached Cluster IN Swarm mode

  clusterkit-mysql-up          Up MySQL Cluster
  clusterkit-mysql-down        Stop MySQL Cluster
  clusterkit-mysql-exec        Execute a command in a running MySQL Cluster node

  clusterkit-mysql-deploy      Deploy MySQL Cluster in Swarm mode
  clusterkit-mysql-remove      Remove MySQL Cluster in Swarm mode

  clusterkit-memcached-up      Up memcached Cluster
  clusterkit-memcached-down    Stop memcached Cluster
  clusterkit-memcached-exec    Execute a command in a running memcached Cluster node

  clusterkit-memcached-deploy  Deploy memcached Cluster in Swarm mode
  clusterkit-memcached-remove  Remove memcached Cluster in Swarm mode

  clusterkit-redis-up          Up Redis Cluster(By Ruby)
  clusterkit-redis-down        Stop Redis Cluster(By Ruby)
  clusterkit-redis-exec        Execute a command in a running Redis Cluster node(By Ruby)

  clusterkit-redis-deploy      Deploy Redis Cluster in Swarm mode(By Ruby)
  clusterkit-redis-remove      Remove Redis Cluster in Swarm mode(By Ruby)

  clusterkit-redis-replication-up       Up Redis M-S (replication)
  clusterkit-redis-replication-down     Stop Redis M-S (replication)
  clusterkit-redis-replication-exec     Execute a command in a running Redis M-S (replication) node

  clusterkit-redis-replication-deploy   Deploy Redis M-S (replication) in Swarm mode
  clusterkit-redis-replication-remove   Remove Redis M-S (replication) in Swarm mode

  clusterkit-redis-sentinel-up           Up Redis S
  clusterkit-redis-sentinel-down         Stop Redis S
  clusterkit-redis-sentinel-exec         Execute a command in a running Redis S node

  clusterkit-redis-sentinel-deploy       Deploy Redis S in Swarm mode
  clusterkit-redis-sentinel-remove       Remove Redis S in Swarm mode

"
exit
}

Function cleanup(){
  Write-Host " "
  logs
  rm log\httpd -Recurse -Force | Out-Null
  rm log\mongodb -Recurse -Force | Out-Null
  rm log\mysql -Recurse -Force | Out-Null
  rm log\mariadb -Recurse -Force | Out-Null
  rm log\nginx -Recurse -Force | Out-Null
  rm log\nginx-unit -Recurse -Force | Out-Null
  rm log\php -Recurse -Force | Out-Null
  rm log\redis -Recurse -Force | Out-Null
  rm log\supervisord | Out-Null
  rm log\supervisord.log | Out-Null
  logs

  printInfo "Cleanup logs files Success"
}

Function _update(){
  if(!(_command git)){
    printError "Git not install, not support update"
    return
  }
  # git remote rm origin
  # git remote add origin git@github.com:khs1994-docker/lnmp
  git fetch --depth=1 origin
  ${BRANCH}=(git rev-parse --abbrev-ref HEAD)
  git reset --hard origin/${BRANCH}
  # git submodule update --init --recursive
}

Function _get_container_id($service){
  $container_id = docker container ls `
      --format "{{.ID}}" `
      -f label=com.khs1994.lnmp `
      -f label=com.docker.compose.service=$service -n 1

  return $container_id
}

Function _bash_cli($service, $command){
  $container_id = _get_container_id $service
  docker exec -it $container_id $command
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

Function satis(){
  if(!(Test-Path ${APP_ROOT}/satis)){
    cp -Recurse app/satis-demo ${APP_ROOT}/satis
    Write-Warning "Please modify ${APP_ROOT}/satis/satis.json"
  }

  docker run --rm -it `
      --mount type=bind,src=${APP_ROOT}/satis,target=/build `
      --mount type=volume,src=lnmp_composer_cache-data,target=/composer composer/satis
}

Function get_compose_options($compose_files,$isBuild=0){
  Foreach ($compose_file in $compose_files)
  {
    $options += " -f $compose_file "
  }
  Foreach ($item in $LREW_INCLUDE)
  {
    $KEY="LREW_${item}_VENDOR".ToUpper();
    $content=$(cat .env | Where-Object {$_ -like "${KEY}=lrew-dev"})

    if(Test-Path $PSScriptRoot/vendor/lrew-dev/$item){
      $LREW_INCLUDE_ROOT="$PSScriptRoot/vendor/lrew-dev/$item"
      # set env
      if(!($content)){
         "${KEY}=lrew-dev" >> .env
      }
    }elseif(Test-Path $PSScriptRoot/vendor/lrew/$item){
      $LREW_INCLUDE_ROOT="$PSScriptRoot/vendor/lrew/$item"
      # unset env
      if($content){
        @(Get-Content .env) -replace `
          "${KEY}=lrew-dev",'' | Set-Content .env
      }
    }elseif(Test-Path $PSScriptRoot/lrew/$item){
      $LREW_INCLUDE_ROOT="$PSScriptRoot/lrew/$item"
    }else{
      continue
    }

    if($isBuild){
      if(!(Test-Path "$LREW_INCLUDE_ROOT\docker-compose.build.yml")){
        $options +=" -f $LREW_INCLUDE_ROOT\docker-compose.yml "
        continue
      }
      $options +=" -f $LREW_INCLUDE_ROOT\docker-compose.yml -f $LREW_INCLUDE_ROOT\docker-compose.build.yml "

      continue
    } # end build

    if (!(Test-Path "$LREW_INCLUDE_ROOT\docker-compose.override.yml")){
      $options +=" -f $LREW_INCLUDE_ROOT\docker-compose.yml "
      continue
    }
    $options +=" -f $LREW_INCLUDE_ROOT\docker-compose.yml -f $LREW_INCLUDE_ROOT\docker-compose.override.yml "
  }

  $options += " -f docker-lnmp.include.yml "

  return $options.split(' ')
}

# main

if (!(Test-Path cli/khs1994-robot.enc )){
  # 在项目目录外
  if ($env:LNMP_PATH.Length -eq 0){
  # 没有设置系统环境变量，则退出
    throw "Please set system environment, more information please see bin/README.md"

  }else{
    # 设置了系统环境变量

    printInfo "Use LNMP CLI in $PWD"
    # cd $env:LNMP_PATH
    cd $PSScriptRoot
    cd $APP_ROOT
    $APP_ROOT=$PWD
    cd $PSScriptRoot
  }

}else {
  printInfo "Use LNMP CLI in LNMP Root $pwd"
  cd $APP_ROOT
  $APP_ROOT=$PWD
  cd $source
}

printInfo "APP_ROOT is $APP_ROOT"

if (!(Test-Path lnmp-docker-custom-script.ps1)){
  Copy-Item lnmp-docker-custom-script.example.ps1 lnmp-docker-custom-script.ps1
}

printInfo "Exec custom script"

. ./lnmp-docker-custom-script.ps1

$env:DOCKER_HOST=$null

if(_command docker){
  if($(docker help context)){

    $isWSL2=docker context ls | where {$_ -match "wsl \*"}

    if($isWSL2){
      printInfo "Docker Engine run in WSL2"
      $env:DOCKER_HOST="npipe:////./pipe/docker_wsl"
    }else{
      $env:DOCKER_HOST="npipe:////./pipe/docker_engine"
    }
  }
}

env_status
logs
check_docker_version

if ($args.Count -eq 0){
  help_information
}else{
  $command, $other = $args
}

Function _lrew_add($packages=$null){
  printInfo "LREW add $packages ..."

  if(!$packages){
     printError "Please Input package name"
     exit 1
  }

  if (!(Test-Path composer.json)){
    composer init -q
    composer config minimum-stability dev
  }

  Foreach($package in $packages){
    composer require lrew/$package --prefer-source
  }

  Foreach($package in $packages){
    if(!(Test-Path $PSScriptRoot/vendor/lrew/$package)){
      continue
    }

    cd $PSScriptRoot/vendor/lrew/$package
    if(Test-Path bin/post-install.ps1){
      . ./bin/post-install.ps1
    }
  }
}

Function _lrew_init($package=$null){
  printInfo "LREW init $package ..."

  if(!$package){
     printError "Please Input package name"
     exit 1
  }

  if(Test-Path vendor/lrew-dev/$package){
     printError "This package already exists"
     return
   }

   cp -r lrew/example vendor/lrew-dev/$package

   if(_command composer){
     composer init -d vendor/lrew-dev/$package `
       --name "lrew/$package" `
       --homepage "https://docs.lnmp.khs1994.com/lrew.html" `
       --license "MIT" `
       -q
   }

   $items="docker-compose.yml","docker-compose.override.yml","docker-compose.build.yml"

   Foreach ($item in $items)
   {
     $file="vendor/lrew-dev/$package/$item"

     @(Get-Content $file) -replace `
       'LREW_EXAMPLE_VENDOR',"LREW_${package}_VENDOR".ToUpper() | Set-Content $file

     @(Get-Content $file) -replace `
       'LNMP_EXAMPLE_',"LNMP_${package}_".ToUpper() | Set-Content $file

     @(Get-Content $file) -replace `
       'example/',"${package}/" | Set-Content $file

     @(Get-Content $file) -replace `
        '{{example}}',"${package}" | Set-Content $file
   }

   if (Test-Path "vendor/lrew-dev/$package/.env.example"){
     cp -r "vendor/lrew-dev/$package/.env.example" "vendor/lrew-dev/$package/.env"
   }
}

Function _lrew_outdated($packages=$null){
  printInfo "LREW check $packages update ..."

  if (!(Test-Path vendor/lrew)){
    return
  }

  if(!$packages){
    composer outdated "lrew/*"
    return
  }

  composer outdated $packages
}

Function _lrew_update($packages=$null){
  printInfo "LREW update $packages ..."

  if (!(Test-Path vendor/lrew)){
    return
  }

  if(!$packages){
    composer update "lrew/*"
    return
  }

  composer update $packages

  Foreach($package in $packages){
    if(!(Test-Path $PSScriptRoot/vendor/lrew/$package)){
      continue
    }

    cd $PSScriptRoot/vendor/lrew/$package
    if(Test-Path bin/post-install.ps1){
      . ./bin/post-install.ps1
    }
  }
}

Function _lrew_backup(){

}

switch -regex ($command){

    init {
      _lrew_init $other
    }

    add {
      _lrew_add $other
    }

    outdated {
      _lrew_outdated $other
    }

    pkg-backup {
      _lrew_backup
    }

    pkg-update {
      _lrew_update $other
    }

    httpd-config {
      clear
      wsl -d $DistributionName lnmp-docker httpd-config $other
    }

    backup {
        docker-compose exec mysql /backup/backup.sh $other
        #@custom
        __lnmp_custom_backup $other
    }

    restore {
       docker-compose exec mysql /backup/restore.sh $other
       #@custom
       __lnmp_custom_restore $other
    }

    build {
      if ($command -eq "build"){
        $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.build.yml" `
                                    1

        & {docker-compose $options build $other --parallel}
      }
    }

    build-config {

      logs

      $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.build.yml" `
                                    1

      & {docker-compose $options config $other}
    }

    build-up {
      $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.build.yml" `
                                    1

      & {docker-compose $options up -d $other}
    }

    build-push {
      $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.build.yml" `
                                    1

      & {docker-compose $options build $other --parallel}

      & {docker-compose $options push $other}
    }

    cleanup {
      cleanup
      #@custom
      __lnmp_custom_cleanup
    }

    config {
      logs

      $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.override.yml"

      & {docker-compose $options config $other}
    }

    cn-mirror {
      clear
      wsl -d $DistributionName lnmp-docker cn-mirror
    }

    checkout {
      git fetch origin "${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}":"${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}"
      git checkout "${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}"
      _update
    }

    services {
      ${LNMP_SERVICES}
    }

    up {
      init

      if($other){
        $services = $other
      }else{
        $services = ${LNMP_SERVICES}
      }

      $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.override.yml"

      & {docker-compose $options up -d $services}

      #@custom
      __lnmp_custom_up $services
    }

    pull {
      $options=get_compose_options "docker-lnmp.yml",`
                                   "docker-lnmp.override.yml"

      & {docker-compose $options pull ${LNMP_SERVICES}}

      #@custom
      __lnmp_custom_pull
    }

    down {
      $options=get_compose_options "docker-lnmp.yml",`
                                   "docker-lnmp.override.yml"

      & {docker-compose $options down --remove-orphans}

      #@custom
      __lnmp_custom_down
    }

    env {
      notepad.exe .env
      notepad.exe .env.ps1
    }

    new {
      clear
      wsl -d $DistributionName lnmp-docker new $other
    }

    nginx-config {
      clear
      wsl -d $DistributionName lnmp-docker nginx-config $other
    }

    swarm-config {
       docker-compose -f docker-production.yml config
    }

    swarm-build {
      docker-compose -f docker-production.yml build $other --parallel
    }

    swarm-push {
      docker-compose -f docker-production.yml push $other
    }

    restart {
      $options=get_compose_options "docker-lnmp.yml", `
                          "docker-lnmp.override.yml"

      & {docker-compose $options restart $other}
      #@custom
      __lnmp_custom_restart $other
    }

    ssl-self {
      docker run --init -it --rm `
        --mount type=bind,src=$pwd/config/nginx/ssl-self,target=/ssl khs1994/tls $other

      printInfo `
'Import ./config/nginx/ssl-self/root-ca.crt to Browsers,then set hosts in C:\Windows\System32\drivers\etc\hosts'
    }

    satis {
      satis
    }

    mongodb-cli {
      if ($other){
        _bash_cli mongodb $other
        exit
      }

      _bash_cli mongodb bash
    }

    mysql-cli {
      if ($other){
        _bash_cli mysql $other
        exit
      }

      _bash_cli mysql bash
    }

    mariadb-cli {
      if ($other){
        _bash_cli mariadb $other
        exit
      }

      _bash_cli mariadb bash
    }

    nginx-unit-cli {
      if ($other){
        _bash_cli nginx-unit $other
        exit
      }

      _bash_cli nginx-unit bash
    }

    php7-cli {
      if ($other){
        _bash_cli php7 $other
        exit
      }

      _bash_cli php7 bash
    }

    "-cli$" {
       $service=($command).split("-cli")

       if ($other){
         _bash_cli $service $other
         exit
       }

       _bash_cli $service sh
    }

    clusterkit {
       $options=get_compose_options "docker-lnmp.yml", `
                                    "docker-lnmp.override.yml", `
                                    "cluster/docker-cluster.mysql.yml", `
                                    "cluster/docker-cluster.redis.yml"

       & {docker-compose $options up $other}
    }

    clusterkit-mysql-up {
       docker-compose -f cluster/docker-cluster.mysql.yml up $other
    }

    clusterkit-mysql-down {
       docker-compose -f cluster/docker-cluster.mysql.yml down $other
    }

    clusterkit-mysql-exec {
         $service,$cmd=$other
         if ($cmd.Count -eq 0){
           '$ ./lnmp-docker.ps1 clusterkit-mysql-exec {master|node-N} {COMMAND}'

           cd $source

           exit 1
         }
         clusterkit_bash_cli clusterkit_mysql mysql_$service $cmd
    }

    clusterkit-memcached-up {
      docker-compose -f cluster/docker-cluster.memcached.yml up $other
    }

    clusterkit-memcached-down {
      docker-compose -f cluster/docker-cluster.memcached.yml down $other
    }

    clusterkit-memcached-exec {
      $service,$cmd=$other
      if ($cmd.Count -eq 0){
        '$ ./lnmp-docker.ps1 clusterkit-memcached-exec {N} {COMMAND}'

        cd $source

        exit 1
      }
      clusterkit_bash_cli clusterkit_memcached memcached-$service $cmd
    }

    clusterkit-redis-up {
          docker-compose -f cluster/docker-cluster.redis.yml up $other
    }

    clusterkit-redis-down {
          docker-compose -f cluster/docker-cluster.redis.yml down $other
    }

    clusterkit-redis-exec {
      $service,$cmd=$other
      if ($cmd.Count -eq 0){
        '$ ./lnmp-docker.ps1 clusterkit-redis-exec {master-N|slave-N} {COMMAND}'

        cd $source

        exit 1
      }
      clusterkit_bash_cli clusterkit_redis redis_$service $cmd
    }

    clusterkit-redis-replication-up {
          docker-compose -f cluster/docker-cluster.redis.replication.yml up $other
    }

    clusterkit-redis-replication-down {
          docker-compose -f cluster/docker-cluster.redis.replication.yml down $other
    }

    clusterkit-redis-replication-exec {
      $service,$cmd=$other
      if ($cmd.Count -eq 0){
        '$ ./lnmp-docker.ps1 clusterkit-redis-replication-exec {master|slave-N} {COMMAND}'

        cd $source

        exit 1
      }
      clusterkit_bash_cli clusterkit_redis_replication redis_m_s_$service $cmd
    }

    clusterkit-redis-sentinel-up {
          docker-compose -f cluster/docker-cluster.redis.sentinel.yml up $other
    }

    clusterkit-redis-sentinel-down {
          docker-compose -f cluster/docker-cluster.redis.sentinel.yml down $other
    }

    clusterkit-redis-sentinel-exec {
      $service,$cmd=$other
      if ($cmd.Count -eq 0){
        '$ ./lnmp-docker.ps1 clusterkit-redis-sentinel-exec {master-N|slave-N|sentinel-N} {COMMAND}'

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

    clusterkit-help {
      clusterkit_help
    }

    update-version {
      clear
      wsl -d $DistributionName lnmp-docker update-version
    }

    bug {
      $os_info=$($psversiontable.BuildVersion)

      if ($os_info.length -eq 0){
        $os_info=$($psversiontable.os)
      }

      $docker_version=$(docker --version)
      $compose_version=$(docker-compose --version)
      $git_commit=$(git log -1 --pretty=%H)
      Write-Output "
<details>

<summary>OS Environment Info</summary>

<code>$os_info</code>

<code>$docker_version</code>

<code>$compose_version</code>

* https://github.com/khs1994-docker/lnmp/commit/$git_commit

</details>

<details>

<summary>Console output</summary>

<!--Don't Edit it-->
<!--Do not manually edit the above, pleae paste the terminal output to the following-->

<pre>



</pre>

</details>

## My Issue is

<!--Describe your problem here-->

XXX

XXX

<!--Be sure to click < Preview > Tab before submitting questions-->
" | Out-File bug.md -encoding utf8

    Start-Process -FilePath https://github.com/khs1994-docker/lnmp/issues
    }

    k8s {
      clear

      printInfo "please try kubernetes on website"
      Start-Process -FilePath "https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61"
    }

    zan {
      clear
      printInfo "Thank You"
      Start-Process -FilePath http://zan.khs1994.com
    }

    donate {
      clear
      printInfo "Thank You"
      Start-Process -FilePath http://zan.khs1994.com
    }

    pcit-up {
      # 判断 app/.pcit 是否存在
      docker rm -f pcit_cp
      rm -r -force ${APP_ROOT}/.pcit
      # git clone --depth=1 https://github.com/pcit-ce/pcit ${APP_ROOT}/.pcit
      docker run -dit --name pcit_cp pcit/pcit:alpine bash
      docker cp pcit_cp:/app/pcit ${APP_ROOT}/.pcit/
      docker rm -f pcit_cp

      # if (!(Test-Path ${APP_ROOT}/pcit/public/.env.produnction)){
      #   cp ${APP_ROOT}/pcit/public/.env.example ${APP_ROOT}/pcit/public/.env.production
      # }

      if (!(Test-Path pcit/.env.development)){
        cp pcit/.env.example pcit/.env.development
      }

      # 判断 nginx 配置文件是否存在

      if(!(Test-Path pcit/conf/pcit.conf)){
        cp pcit/conf/pcit.config pcit/conf/pcit.conf
      }

      $a=Select-String 'demo.ci.khs1994.com' pcit/conf/pcit.conf

      if ($a.Length -ne 0){
        throw "PCIT nginx conf error, please see pcit/README.md"
      }

      if(!(Test-Path pcit/ssl/ci.crt)){
        throw "PCIT Website SSL key not found, please see pcit/README.md"
      }

      if(!(Test-Path pcit/key/private.key)){
        throw "PCIT GitHub App private key not found, please see pcit/README.md"
      }

      if(!(Test-Path pcit/key/public.key)){
        docker run -it --rm --mount type=bind,src=$PWD/pcit/key,target=/app pcit/pcit:alpine `
          openssl rsa -in private.key -pubout -out public.key
      }

      cp pcit/ssl/ci.crt config/nginx/ssl/ci.crt

      cp pcit/conf/pcit.conf config/nginx/pcit.conf

      # GitHub App private key

      cp pcit/key/* ${APP_ROOT}/.pcit/framework/storage/private_key/

      # env file

      cp pcit/.env.development ${APP_ROOT}/.pcit/.env.development

      # 启动
      $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.override.yml"

      & {docker-compose $options up -d ${LNMP_SERVICES} pcit}
    }

    "cookbooks" {
      printInfo k8s
      if(!(Test-Path ${APP_ROOT}/lnmp-docs/k8s)){
        git clone --depth=1 -b gh-pages git@gitee.com:khs1994-website/kubernetes-handbook.git ${APP_ROOT}/lnmp-docs/k8s
      }else{
        git -C ${APP_ROOT}/lnmp-docs/k8s fetch --depth=1 origin gh-pages
        git -C ${APP_ROOT}/lnmp-docs/k8s reset --hard origin/gh-pages
      }

      printInfo docker_practice
      if(!(Test-Path ${APP_ROOT}/lnmp-docs/docker_practice)){
        git clone --depth=1 -b master git@github.com:docker_practice/zh-cn.git ${APP_ROOT}/lnmp-docs/docker_practice
      }else{
        git -C ${APP_ROOT}/lnmp-docs/docker_practice fetch --depth=1 origin master
        git -C ${APP_ROOT}/lnmp-docs/docker_practice reset --hard origin/master
      }

      printInfo laravel
      if(!(Test-Path ${APP_ROOT}/lnmp-docs/laravel)){
        git clone --depth=1 -b gh-pages git@gitee.com:khs1994-website/laravel-docs.zh-cn.git ${APP_ROOT}/lnmp-docs/laravel
      }else{
        git -C ${APP_ROOT}/lnmp-docs/laravel fetch --depth=1 origin gh-pages
        git -C ${APP_ROOT}/lnmp-docs/laravel reset --hard origin/gh-pages
      }

      printInfo laravel_en
      if(!(Test-Path ${APP_ROOT}/lnmp-docs/laravel-en)){
        git clone --depth=1 -b gh-pages git@gitee.com:khs1994-website/laravel-docs.us-en.git ${APP_ROOT}/lnmp-docs/laravel-en
      }else{
        git -C ${APP_ROOT}/lnmp-docs/laravel-en fetch --depth=1 origin gh-pages
        git -C ${APP_ROOT}/lnmp-docs/laravel-en reset --hard origin/gh-pages
      }

      printInfo nginx
      if(!(Test-Path ${APP_ROOT}/lnmp-docs/nginx)){
        git clone --depth=1 -b gh-pages git@gitee.com:khs1994-website/nginx-docs.zh-cn.git ${APP_ROOT}/lnmp-docs/nginx
      }else{
        git -C ${APP_ROOT}/lnmp-docs/nginx fetch --depth=1 origin gh-pages
        git -C ${APP_ROOT}/lnmp-docs/nginx reset --hard origin/gh-pages
      }
    }

    daemon-socket {
      docker run -d --restart=always `
        -p 2376:2375 `
        --mount type=bind,src=/var/run/docker.sock,target=/var/run/docker.sock `
        -e PORT=2375 `
        --health-cmd="wget 127.0.0.1:2375/info -O /proc/self/fd/2" `
        shipyard/docker-proxy
    }

    wait-docker {
      wait_docker
    }

    gcr.io {
      printInfo "Check gcr.io host config"

      $GCR_IO_HOST=(ping gcr.io -n 1).split(" ")[9]
      $GCR_IO_HOST_EN=(ping gcr.io -n 1).split(" ")[11].trim(":")

      if(!(($GCR_IO_HOST -eq "127.0.0.1") -or ($GCR_IO_HOST_EN -eq "127.0.0.1"))){
        printWarning "Please set host on C:\Windows\System32\drivers\etc

127.0.0.1 gcr.io k8s.gcr.io
"

        explorer.exe C:\Windows\System32\drivers\etc
        exit
      }

      printInfo "gcr.io host config correct"

      if ('logs' -eq $args[1]){
        docker logs $(docker container ls -f label=com.khs1994.lnmp.gcr.io -q) -f
        exit
      }

      docker container rm -f `
          $(docker container ls -a -f label=com.khs1994.lnmp.gcr.io -q) | out-null

printInfo "This local server support Docker Desktop EDGE v${DOCKER_DESKTOP_VERSION} with Kubernetes ${KUBERNETES_VERSION}"

      if ('down' -eq $args[1]){
        Write-Warning "Stop gcr.io local server success"
        exit
      }

      if (!(Test-Path data/registry)){
        mkdir data/registry
      }

      docker run -it -d `
        -p 443:443 `
        -p 80:80 `
        --mount type=bind,src=$pwd/config/registry/config.gcr.io.yml,target=/etc/docker/registry/config.yml `
        --mount type=bind,src=$pwd/config/registry,target=/etc/docker/registry/ssl `
        --mount type=bind,src=$pwd/data/registry,target=/var/lib/registry `
        --label com.khs1994.lnmp.gcr.io `
        registry

      if ('--no-pull' -eq $args[1]){
        printInfo "Up gcr.io Server Success"
        exit
      }

      $images="kube-controller-manager:v${KUBERNETES_VERSION}", `
      "kube-apiserver:v${KUBERNETES_VERSION}", `
      "kube-scheduler:v${KUBERNETES_VERSION}", `
      "kube-proxy:v${KUBERNETES_VERSION}", `
      "etcd:3.3.10", `
      "coredns:1.3.1", `
      "pause:3.1"

      sleep 10

      foreach ($image in $images){
         printInfo "Handle ${image}"
         docker pull gcr.io/google-containers/$image
         docker tag  gcr.io/google-containers/$image k8s.gcr.io/$image
         # docker push k8s.gcr.io/$image
         docker rmi  gcr.io/google-containers/$image
      }

      docker container rm -f `
          $(docker container ls -a -f label=com.khs1994.lnmp.gcr.io -q) | out-null
    }

    composer {
        $LARAVEL_ROOT,$COMPOSER_COMMAND=$other

        $options=get_compose_options "docker-lnmp.yml",`
                                     "docker-lnmp.override.yml"

        & {docker-compose $options run -w $LARAVEL_ROOT composer $COMPOSER_COMMAND}
      }

    default {
        #@custom
        __lnmp_custom_command $args
        printInfo `
"Exec docker-compose command, maybe you input command is notdefined, then output docker-compose help information"
        $options=get_compose_options "docker-lnmp.yml",`
                                     "docker-lnmp.override.yml"

        & {docker-compose $options $args}
      }
}

cd $source
