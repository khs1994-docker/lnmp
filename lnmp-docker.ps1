
<#PSScriptInfo

.VERSION 19.03.8-alpha1

.GUID 9769fa4f-70c7-43ed-8d2b-a0018f7dc89f

.AUTHOR khs1994@khs1994.com

.COMPANYNAME khs1994-docker

.COPYRIGHT khs1994@khs1994.com

.TAGS docker lnmp

.LICENSEURI https://github.com/khs1994-docker/lnmp/blob/master/LICENSE

.PROJECTURI https://github.com/khs1994-docker/lnmp

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


#>

<#
.SYNOPSIS
  khs1994-docker/lnmp CLI
.DESCRIPTION
  khs1994-docker/lnmp CLI
.EXAMPLE
  PS C:\> lnmp-docker up
.INPUTS

.OUTPUTS

.NOTES
  khs1994-docker/lnmp CLI
#>

$LNMP_CACHE="$HOME/.khs1994-docker-lnmp"

if ($args[0] -eq "install"){
  git clone -b 19.03 --depth=1 https://github.com/khs1994-docker/lnmp.git ~/lnmp

  exit
}

$outNull=$false

if (${QUITE} -eq $true){
  $outNull=$true
}

if ($args[0] -eq "services"){
  $outNull=$true
}

Function printInfo(){
  if($outNull){
    return
  }
Write-Host "`nINFO    " -NoNewLine -ForegroundColor Green
Write-Host "$args`n";
}

Function getEnvFile(){
  $LNMP_ENV_FILE=".env"
  $LNMP_ENV_FILE_PS1=".env.ps1"
  if($env:LNMP_ENV){
    if (Test-Path(".env.$env:LNMP_ENV")){
      write-host 1
      $LNMP_ENV_FILE=".env.$env:LNMP_ENV"
    }

    if (Test-Path(".env.$env:LNMP_ENV.ps1")){
      $LNMP_ENV_FILE_PS1=".env.$env:LNMP_ENV.ps1"
    }
  }

  return $LNMP_ENV_FILE,$LNMP_ENV_FILE_PS1
}

$LNMP_ENV_FILE,$LNMP_ENV_FILE_PS1=getEnvFile

if($args[0] -eq "env-file"){
  echo $LNMP_ENV_FILE,$LNMP_ENV_FILE_PS1

  exit
}

printInfo "Load env file [ $LNMP_ENV_FILE ] and [ $LNMP_ENV_FILE_PS1 ]"

. "$PSScriptRoot/.env.example.ps1"

. "$PSScriptRoot/cli/.env.ps1"

if (Test-Path "$PSScriptRoot/$LNMP_ENV_FILE_PS1"){
  . "$PSScriptRoot/$LNMP_ENV_FILE_PS1"
}

# [environment]::SetEnvironmentvariable("DOCKER_DEFAULT_PLATFORM", "linux", "User");

# $ErrorActionPreference="SilentlyContinue"
# Stop, Continue, Inquire, Ignore, Suspend, Break

# $DOCKER_DEFAULT_PLATFORM="linux"
$KUBERNETES_VERSION="1.15.5"
$DOCKER_DESKTOP_VERSION="2.1.5.0 (40323)"
$source=$PWD

Function _command($command){
  get-command $command -ErrorAction "SilentlyContinue"

  return $?
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
    Write-Warning '.env file NOT existing, maybe first run'
    cp .env.example .env
  }

  if (Test-Path .env.ps1){
    printInfo ".env.ps1 file existing"
  }else{
    Write-Warning ".env.ps1 file NOT existing, maybe first run"
    cp .env.example.ps1 .env.ps1
  }

  _cp_only_not_exists kubernetes/nfs-server/.env.example kubernetes/nfs-server/.env

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

  _cp_only_not_exists wsl2/.env.example.ps1 wsl2/.env.ps1

  _cp_only_not_exists wsl2/config/coredns/corefile.example wsl2/config/coredns/corefile
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

  if(!(_command docker)){
    printError "Docker not install"

    return
  }

  ${BRANCH}=(git rev-parse --abbrev-ref HEAD)

  if (!("${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}" -eq "${BRANCH}" )) {
    printWarning "Current branch ${BRANCH} incompatible with your docker version, please checkout ${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM} branch by exec $ ./lnmp-docker checkout"
  }
}

Function init(){
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

Run Kubernetes on Tencent Cloud:
  k8s                  Run Kubernetes on Tencent Cloud

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
  compose              Install docker-compose [PATH]
  composer             Exec composer command on Docker Container
  bug                  Generate Debug information, then copy it to GitHub Issues
  daemon-socket        Expose Docker daemon on tcp://0.0.0.0:2376 without TLS
  env                  Edit .env/.env.ps1 file
  help                 Display this help message
  hosts                Open hosts files
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


WSL2:

  dockerd              Start Dockerd on WSL2

Read './docs/*.md' for more information about CLI commands.

You can open issue in [ https://github.com/khs1994-docker/lnmp/issues ] when you meet problems.

You must Update .env file when update this project.

Exec '$ lnmp-docker k8s' Run Kubernetes on Tencent Cloud

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

  if(! $(git remote get-url origin)){
    printError "git remote origin not set, setting ..."
    # git remote add origin git@github.com:khs1994-docker/lnmp
    git remote add origin https://github.com/khs1994-docker/lnmp
  }

  # git remote rm origin
  if($(git status).split("")[-1] -eq 'clean' -eq $False){
    printError "Somefile changed, please commit or stash first"
    exit 1
  }

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
    $KEY="LREW_$($item -Replace ('-','_'))_VENDOR".ToUpper();
    $content=$(cat $LNMP_ENV_FILE | Where-Object {$_ -like "${KEY}=lrew-dev"})

    # dev
    if(Test-Path $PSScriptRoot/vendor/lrew-dev/$item){
      $LREW_INCLUDE_ROOT="$PSScriptRoot/vendor/lrew-dev/$item"
      # set env
      if(!($content)){
         "${KEY}=lrew-dev" >> $LNMP_ENV_FILE
      }
    }elseif(Test-Path $PSScriptRoot/vendor/lrew2/$item){
      $LREW_INCLUDE_ROOT="$PSScriptRoot/vendor/lrew2/$item"
      # unset env
      if($content){
        @(Get-Content $LNMP_ENV_FILE) -replace `
          "${KEY}=lrew-dev",'' | Set-Content $LNMP_ENV_FILE
      }
    }elseif(Test-Path $PSScriptRoot/vendor/lrew/$item){
      $LREW_INCLUDE_ROOT="$PSScriptRoot/vendor/lrew/$item"
      # unset env
      if($content){
        @(Get-Content $LNMP_ENV_FILE) -replace `
          "${KEY}=lrew-dev",'' | Set-Content $LNMP_ENV_FILE
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

  $options += " --env-file $LNMP_ENV_FILE "

  $options += " -f docker-lnmp.include.yml "

  return $options.split(' ')
}

Function _lrew_add($packages=$null){
  printInfo "LREW add $packages ..."

  if(!$packages){
     printError "Please Input package name"
     exit 1
  }

  if (!(Test-Path composer.json)){
    composer init -q -n --stability dev
  }
  Foreach($package in $packages){
    $ErrorActionPreference="continue"
    composer require "lrew/$package" --prefer-source
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
     composer init -d "vendor/lrew-dev/$package" `
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
       'LREW_EXAMPLE_VENDOR',"LREW_$( $package -Replace('-','_'))_VENDOR".ToUpper() | Set-Content $file

     @(Get-Content $file) -replace `
       'LNMP_EXAMPLE_',"LNMP_$( $package -Replace('-','_'))_".ToUpper() | Set-Content $file

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

Function _wsl_check(){
  wsl -d $DistributionName echo ""

  if(!$?){
    printError "wsl [ $DistributionName ] not found, please check [ $LNMP_ENV_FILE_PS1 ] file `$DistributionName value"
    exit 1
  }
}

# main

if (!(Test-Path cli/khs1994-robot.enc )){
  # 在项目目录外
  if ($env:LNMP_PATH.Length -eq 0){
  # 没有设置系统环境变量，则退出
    throw "Please set system environment LNMP_PATH, more information please see bin/README.md"

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

Function _wsl2_docker_init(){
  wsl -u root -- chmod -R 777 log
  $env:COMPOSE_CONVERT_WINDOWS_PATHS=1
  wsl -u root -- ls /c/Users | out-null
  if(!$?){
    printError "WSL2 must mount C to /c"

    exit 1
  }
}

$isWSL2=$false

if((_command docker) -and ($PSVersionTable.Platform -eq "Win32NT" -or $PSVersionTable.Platform -eq $null) -and (Test-Path $HOME\.docker\config.json)){
  $docker_current_context=(ConvertFrom-Json -InputObject (get-content $HOME\.docker\config.json -Raw)).currentContext

  if ($docker_current_context -eq "wsl2"){
    printInfo "Docker Engine run in WSL2 (start by $ service docker start)"
    $LNMP_COMPOSE_GLOBAL_OPTIONS="-H ${LNMP_WSL2_DOCKER_HOST}"
    _wsl2_docker_init
    $isWSL2=$true
  }else{
      # $LNMP_COMPOSE_GLOBAL_OPTIONS="-H npipe:////./pipe/docker_engine"
  }
}

# context is wsl2, exec slow
if(_command docker){
  if(!$isWSL2){
    $DOCKER_VERSION=$($(docker --version).split(' ')[2]).trim(',')
  }else{
    $DOCKER_VERSION=$($(docker -c default --version).split(' ')[2]).trim(',')
  }
}

$DOCKER_VERSION_YY=([System.Version]$DOCKER_VERSION).Major
$DOCKER_VERSION_MM="0" + ([System.Version]$DOCKER_VERSION).Minor

env_status
logs
check_docker_version

if(_command docker-compose){
  printInfo $(docker-compose --version)
}

if ($args.Count -eq 0){
  help_information
}else{
  $command, $other = $args
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

    lrew-backup {
      _lrew_backup
    }

    lrew-update {
      _lrew_update $other
    }

    httpd-config {
      clear
      _wsl_check
      wsl -d $DistributionName ./lnmp-docker httpd-config $other
    }

    backup {
        docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} exec mysql /backup/backup.sh $other
        #@custom
        __lnmp_custom_backup $other
    }

    restore {
       docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} exec mysql /backup/restore.sh $other
       #@custom
       __lnmp_custom_restore $other
    }

    build {
      if ($command -eq "build"){
        $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.build.yml" `
                                    1

        & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options build $other --parallel}
      }
    }

    build-config {

      logs

      $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.build.yml" `
                                    1

      & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options config $other}
    }

    build-up {
      $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.build.yml" `
                                    1

      & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options up -d $other}
    }

    build-push {
      $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.build.yml" `
                                    1

      & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options build $other --parallel}

      & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options push $other}
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

      & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options config $other}
    }

    checkout {
      git fetch origin "${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}":"${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}"
      git checkout "${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}"
      _update
    }

    services {
      ${LNMP_SERVICES}
    }

    "^up$" {
      init

      if($other){
        $services = $other
      }else{
        $services = ${LNMP_SERVICES}
      }

      $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.override.yml"

      & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options up -d $services}

      #@custom
      __lnmp_custom_up $services
    }

    pull {
      $options=get_compose_options "docker-lnmp.yml",`
                                   "docker-lnmp.override.yml"

      & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options pull ${LNMP_SERVICES}}

      #@custom
      __lnmp_custom_pull
    }

    down {
      $options=get_compose_options "docker-lnmp.yml",`
                                   "docker-lnmp.override.yml"

      & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options down --remove-orphans}

      #@custom
      __lnmp_custom_down
    }

    env {
      if($other){
        notepad.exe $other
        exit
      }

      notepad.exe $LNMP_ENV_FILE
      notepad.exe $LNMP_ENV_FILE_PS1
    }

    new {
      clear
      _wsl_check
      wsl -d $DistributionName ./lnmp-docker new $other
    }

    nginx-config {
      clear
      _wsl_check
      wsl -d $DistributionName ./lnmp-docker nginx-config $other
    }

    swarm-config {
       docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-production.yml config
    }

    swarm-build {
      docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-production.yml build $other --parallel
    }

    swarm-push {
      docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-production.yml push $other
    }

    restart {
      $options=get_compose_options "docker-lnmp.yml", `
                          "docker-lnmp.override.yml"

      & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options restart $other}
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

       & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options up $other}
    }

    clusterkit-mysql-up {
       docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.mysql.yml up $other
    }

    clusterkit-mysql-down {
       docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.mysql.yml down $other
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
      docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.memcached.yml up $other
    }

    clusterkit-memcached-down {
      docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.memcached.yml down $other
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
          docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.yml up $other
    }

    clusterkit-redis-down {
          docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.yml down $other
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
          docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.replication.yml up $other
    }

    clusterkit-redis-replication-down {
          docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.replication.yml down $other
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
          docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.sentinel.yml up $other
    }

    clusterkit-redis-sentinel-down {
          docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.sentinel.yml down $other
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
      _wsl_check
      wsl -d $DistributionName ./lnmp-docker update-version
    }

    bug {
      $os_info=$($psversiontable.BuildVersion)

      if ($os_info.length -eq 0){
        $os_info=$($psversiontable.os)
      }

      $docker_version=$(docker --version)
      $compose_version=$(docker-compose --version)
      $git_commit=$(git log -1 --pretty=%H)
      Write-Output "<details>
%0A
<summary>OS Environment Info</summary>
%0A%0A
<code>OS: $os_info</code>
%0A%0A
<code>Docker: $docker_version</code>
%0A%0A
<code>Docker Compose: $compose_version</code>
%0A%0A
<code>LNMP COMMIT: https://github.com/khs1994-docker/lnmp/commit/$git_commit</code>
%0A%0A
</details>
%0A%0A
<details>
%0A%0A
<summary>Console output</summary>
%0A%0A
<!--Don't Edit it-->
%0A
<!--Do not manually edit the above, pleae paste the terminal output to the following-->
%0A%0A
<pre>

%0A
%0A
%0A
%0A
%0A
%0A
%0A
%0A

</pre>
%0A%0A
</details>
%0A%0A
<h2>My Issue is</h2>
%0A
<!--Describe your problem here-->

%0A%0A
XXX
%0A%0A
XXX
%0A%0A

<!--Be sure to click < Preview > Tab before submitting questions-->
" | Out-File bug.md -encoding utf8

    # Start-Process -FilePath https://github.com/khs1994-docker/lnmp/issues
    Start-Process -FilePath https://github.com/khs1994-docker/lnmp/issues/new?body=$(cat bug.md)
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

    fund {
      clear
      printInfo "Thank You"
      Start-Process -FilePath http://zan.khs1994.com
    }

    pcit-up {
      # 判断 app/.pcit 是否存在
      rm -r -force ${APP_ROOT}/.pcit
      # git clone --depth=1 https://github.com/pcit-ce/pcit ${APP_ROOT}/.pcit
      docker pull pcit/pcit:frontend
      docker run -it --rm -v ${APP_ROOT}/.pcit/public:/var/www/pcit/public pcit/pcit:frontend

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
        docker run -it --rm --mount type=bind,src=$PWD/pcit/key,target=/app pcit/pcit `
          openssl rsa -in private.key -pubout -out public.key
      }

      cp pcit/ssl/ci.crt config/nginx/ssl/ci.crt

      cp pcit/conf/pcit.conf config/nginx/pcit.conf

      # 启动
      $options=get_compose_options "docker-lnmp.yml", `
                                   "docker-lnmp.override.yml"

      & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options up -d ${LNMP_SERVICES} pcit}
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

      mkdir -Force $LNMP_CACHE/registry | out-null

      docker run -it -d `
        -p 443:443 `
        -p 80:80 `
        --mount type=bind,src=$pwd/config/registry/config.gcr.io.yml,target=/etc/docker/registry/config.yml `
        --mount type=bind,src=$pwd/config/registry,target=/etc/docker/registry/ssl `
        --mount type=bind,src=$LNMP_CACHE/registry,target=/var/lib/registry `
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
      if((Test-Path $source/.devcontainer) -And (Test-Path $source/docker-workspace.yml)){
        printInfo "Exec composer command in vscode remote folder"
        cd $source
        docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-workspace.yml run --rm composer $args

        exit
      }

        $WORKING_DIR,$COMPOSER_COMMAND=$other

        if(!$WORKING_DIR){
          "Some ARGs require

Usage: ./lnmp-docker composer PATH_IN_CONTAINER COMPOSER_COMMAND

Example: ./lnmp-docker composer /app/demo install
"

          exit 1
        }

        $options=get_compose_options "docker-lnmp.yml",`
                                     "docker-lnmp.override.yml"

        & {docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options run -w $WORKING_DIR --rm composer $COMPOSER_COMMAND}
      }

    hosts {
      Start-Process -FilePath "notepad.exe" `
        -ArgumentList "C:\Windows\System32\drivers\etc\hosts" `
        -Verb RunAs
    }

    dockerd {
      & $PSScriptRoot/wsl2/bin/dockerd-wsl2.ps1 $other
    }

    "compose$" {
      $DIST="C:\ProgramData\DockerDesktop\version-bin\docker-compose.exe"
      if($other){
        $DIST=$other

        if($other.count -gt 1){
          $DIST=$other[0]
        }
      }

      printInfo "Download docker-compose $LNMP_DOCKER_COMPOSE_VERSION to $DIST ..."

      start-process "curl.exe" -ArgumentList "-L","https://github.com/docker/compose/releases/download/${LNMP_DOCKER_COMPOSE_VERSION}/docker-compose-Windows-x86_64.exe","-o","$DIST" -Verb Runas -wait -WindowStyle Hidden
    }

    default {
        #@custom
        __lnmp_custom_command $args
        printInfo `
"maybe you input command is notdefined, TRY EXEC docker-compose command"
        $options=get_compose_options "docker-lnmp.yml",`
                                     "docker-lnmp.override.yml"

        $command,$other = $args
        & {docker-compose $options $command $other}
      }
}

cd $source
