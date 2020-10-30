
<#PSScriptInfo

.VERSION 20.10.1

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

  PS C:\> lnmp-docker up
.EXAMPLE
  PS C:\> lnmp-docker up
.INPUTS

.OUTPUTS

.NOTES
  khs1994-docker/lnmp CLI
#>

$LNMP_CACHE = "$HOME/.khs1994-docker-lnmp"
$env:WSLENV = $null
$env:COMPOSE_FILE = $null

if ($args[0] -eq "install") {
  if (get-command git) {
    git clone -b 20.10 --depth=1 https://github.com/khs1994-docker/lnmp.git $home\lnmp

    exit
  }

  write-warning "Please download and install git:

Official: https://github.com/git-for-windows/git/releases

CN_Mirror: https://mirrors.huaweicloud.com/git-for-windows/
"

  exit 1
}

$outNull = $false

if (${QUITE} -eq $true) {
  $outNull = $true
}

if ($args[0] -eq "services") {
  $outNull = $true
}

Function printInfo() {
  if ($outNull) {
    return
  }
  Write-Host "INFO    " -NoNewLine -ForegroundColor Green
  Write-Host "$args";
}

Function getEnvFile() {
  $LNMP_ENV_FILE = ".env"
  $LNMP_ENV_FILE_PS1 = ".env.ps1"
  if ($env:LNMP_ENV) {
    if (Test-Path("$PSScriptRoot/.env.${env:LNMP_ENV}")) {
      $LNMP_ENV_FILE = ".env.${env:LNMP_ENV}"
    }

    if (Test-Path("$PSScriptRoot/.env.${env:LNMP_ENV}.ps1")) {
      $LNMP_ENV_FILE_PS1 = ".env.${env:LNMP_ENV}.ps1"
    }
  }

  return $LNMP_ENV_FILE, $LNMP_ENV_FILE_PS1
}

$LNMP_ENV_FILE, $LNMP_ENV_FILE_PS1 = getEnvFile

if ($args[0] -eq "env-file") {
  echo $LNMP_ENV_FILE, $LNMP_ENV_FILE_PS1

  exit
}

if (!(Test-Path $PSScriptRoot\cli\khs1994-robot.enc )) {
  Write-Host "lnmp-docker.ps1 not in lnmp ROOT PATH" -ForegroundColor Red

  Write-Host "Please remove $((get-command lnmp-docker).Source)" -ForegroundColor Red

  exit 1
}

printInfo "Load env file [ $LNMP_ENV_FILE ] and [ $LNMP_ENV_FILE_PS1 ]"

. "$PSScriptRoot/.env.example.ps1"

. "$PSScriptRoot/cli/.env.ps1"

if (Test-Path "$PSScriptRoot/$LNMP_ENV_FILE_PS1") {
  . "$PSScriptRoot/$LNMP_ENV_FILE_PS1"
}

# [environment]::SetEnvironmentvariable("DOCKER_DEFAULT_PLATFORM", "linux", "User");

# $ErrorActionPreference="SilentlyContinue"
# Stop, Continue, Inquire, Ignore, Suspend, Break

# $DOCKER_DEFAULT_PLATFORM="linux"
$KUBERNETES_VERSION = "1.19.2"
$DOCKER_DESKTOP_VERSION = "2.4.2.0"
$EXEC_CMD_DIR = $PWD

Function Test-Command($command) {
  get-command $command -ErrorAction "SilentlyContinue"

  return $?
}

Function printError() {
  if ($outNull) {
    return
  }
  Write-Host "Error   " -NoNewLine -ForegroundColor Red
  Write-Host "$args";
}

Function printWarning() {
  if ($outNull) {
    return
  }
  Write-Host "Warning  " -NoNewLine -ForegroundColor Red
  Write-Host "$args";
}

Function _cp_only_not_exists($src, $desc) {
  if (!(Test-Path $desc)) {
    Copy-Item $src $desc
  }
}

Function New-InitFile() {
  _cp_only_not_exists kubernetes/nfs-server/.env.example kubernetes/nfs-server/.env

  _cp_only_not_exists config/supervisord/supervisord.ini.example config/supervisord/supervisord.ini

  if (!(Test-Path secrets/minio/key.txt)) {
    Copy-Item secrets/minio/key.example.txt secrets/minio/key.txt
    Copy-Item secrets/minio/secret.example.txt secrets/minio/secret.txt
  }

  if (!(Test-Path config/redis/redis.conf)) {
    Write-Output "#" | Out-File config/redis/redis.conf
  }

  _cp_only_not_exists docker-lnmp.include.example.yml docker-lnmp.include.yml

  _cp_only_not_exists docker-workspace.example.yml docker-workspace.yml

  _cp_only_not_exists config/php/docker-php.example.ini config/php/docker-php.ini
  _cp_only_not_exists config/php/php.development.ini config/php/php.ini
  _cp_only_not_exists config/php/zz-docker.example.conf config/php/zz-docker.conf
  _cp_only_not_exists config/php8/docker-php.example.ini config/php8/docker-php.ini
  _cp_only_not_exists config/php8/php.development.ini config/php8/php.ini
  _cp_only_not_exists config/php8/zz-docker.example.conf config/php8/zz-docker.conf

  _cp_only_not_exists config/npm/.npmrc.example config/npm/.npmrc
  _cp_only_not_exists config/npm/.env.example config/npm/.env

  _cp_only_not_exists config/yarn/.yarnrc.example config/yarn/.yarnrc
  _cp_only_not_exists config/yarn/.env.example config/yarn/.env

  _cp_only_not_exists config/crontabs/root.example config/crontabs/root

  _cp_only_not_exists config/composer/.env.example config/composer/.env
  _cp_only_not_exists config/composer/.env.example.ps1 config/composer/.env.ps1
  _cp_only_not_exists config/composer/config.example.json config/composer/config.json

  _cp_only_not_exists config/registry/config.example.yml config/registry/config.yml

  _cp_only_not_exists wsl2/.env.example.ps1 wsl2/.env.ps1

  _cp_only_not_exists wsl2/config/coredns/corefile.example wsl2/config/coredns/corefile
}

Function Wait-Docker() {
  while ($i -lt (300)) {
    $i += 1
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

Function New-LogFile() {
  if (! (Test-Path log\httpd)) {
    New-Item log\httpd -type directory | Out-Null
  }
  if (! (Test-Path log\mongodb)) {
    New-Item log\mongodb -type directory | Out-Null
    New-Item log\mongodb\mongo.log -type file | Out-Null
  }
  if (-not (Test-Path log\mysql)) {
    New-Item log\mysql -type directory | Out-Null
    New-Item log\mysql\error.log -type file | Out-Null
  }
  if (-not (Test-Path log\mariadb)) {
    New-Item log\mariadb -type directory | Out-Null
    New-Item log\mariadb\error.log -type file | Out-Null
  }
  if (! (Test-Path log\nginx)) {
    New-Item log\nginx -type directory | Out-Null
    New-Item log\nginx\access.log -type file | Out-Null
    New-Item log\nginx\error.log -type file | Out-Null
  }
  if (! (Test-Path log\nginx-unit)) {
    New-Item log\nginx-unit -type directory | Out-Null
  }
  if (! (Test-Path log\php)) {
    New-Item log\php -type directory | Out-Null
    New-Item log\php\error.log -type file | Out-Null
    New-Item log\php\php-fpm-slow.log -type file | Out-Null
    New-Item log\php\php-fpm-error.log -type file | Out-Null
    New-Item log\php\php-fpm-access.log -type file | Out-Null
    New-Item log\php\xdebug-remote.log -type file | Out-Null
  }
  if (! (Test-Path log\redis)) {
    New-Item log\redis -type directory | Out-Null
    New-Item log\redis\redis.log -type file | Out-Null
  }

  if (! (Test-Path log\supervisord)) {
    New-Item log\supervisord -type directory | Out-Null
  }

  if (! (Test-Path log\supervisord.log)) {
    New-Item log\supervisord.log | Out-Null
  }
}

Function Test-DockerVersion() {
  if (!(Test-Command git)) {
    printError "Git not install"
    return
  }

  if (!(Test-Command docker)) {
    printError "Docker not install"
    return
  }

  ${BRANCH} = (git rev-parse --abbrev-ref HEAD)

  if (!("${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}" -eq "${BRANCH}" )) {
    printWarning "Current branch ${BRANCH} incompatible with your docker version, please checkout ${DOCKER_VERSION_YY}`.${DOCKER_VERSION_MM} branch by exec $ ./lnmp-docker checkout"
  }
}

Function init() {
  New-LogFile
  # git submodule update --init --recursive
  printInfo 'Init success'
  #@custom
  __lnmp_custom_init
}

Function help_information() {
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
  build                Build or rebuild your LNMP images (Only Support x86_64)
  build-config         Validate and view the LNMP with your images Compose file
  build-up             Create and start LNMP containers With your Build images
  build-push           Pushes your images to Docker Registory
  build-pull           Pull LNMP Docker Images Build By your self
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
  code                 Open WSL2 app path on vscode wsl remote [ SUB_DIR ] (e.g. ./lnmp-docker code laravel)
  code-init            Init vsCode remote development env
  code-run             Run command on vsCode remote workspace (e.g. ./lnmp-docker code-run -w /app/laravel composer install)
  code-exec            Exec command on vsCode remote workspace (e.g. ./lnmp-docker code-exec -w /app/laravel workspace composer install)

lrew(package):
  lrew-init            Init a new lrew package
  lrew-add             Add new lrew package
  lrew-outdated        Shows a list of installed lrew packages that have updates available
  lrew-backup          Upload composer.json to GitHub Gist
  lrew-update          Update lrew package

PHP Tools:
  new                  New PHP Project and generate nginx conf and issue SSL certificate
  httpd-config         Generate Apache2 vhost conf
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

  cd $EXEC_CMD_DIR

  exit
}

Function clusterkit_help() {
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

Function cleanup() {
  New-LogFile
  Remove-Item -Recurse -Force log\httpd  | Out-Null
  Remove-Item -Recurse -Force log\mongodb | Out-Null
  Remove-Item -Recurse -Force log\mysql | Out-Null
  Remove-Item -Recurse -Force log\mariadb  | Out-Null
  Remove-Item -Recurse -Force log\nginx | Out-Null
  Remove-Item -Recurse -Force log\nginx-unit | Out-Null
  Remove-Item -Recurse -Force log\php | Out-Null
  Remove-Item -Recurse -Force log\redis | Out-Null
  Remove-Item -Recurse -Force log\supervisord | Out-Null
  Remove-Item -Recurse -Force log\supervisord | Out-Null
  Remove-Item -Recurse -Force log\supervisord.log | Out-Null
  New-LogFile

  printInfo "Cleanup logs files Success"
}

Function _update() {
  if (!(Test-Command git) -or !(Test-Path .git)) {
    printError "Git not install or this folder not git project, not support update"
    return
  }

  if (! $(git remote get-url origin)) {
    printError "git remote origin not set, setting ..."
    # git remote add origin git@github.com:khs1994-docker/lnmp
    git remote add origin https://github.com/khs1994-docker/lnmp
  }

  # git remote rm origin
  if (!($(git status).split(" ")[-1] -eq 'clean')) {
    printError "Somefile changed, please commit or stash first"
    exit 1
  }

  ${BRANCH} = (git rev-parse --abbrev-ref HEAD)
  $ErrorActionPreference = "continue"
  git pull origin ${BRANCH}
  git reset --hard origin/${BRANCH}
  # git submodule update --init --recursive
}

Function Get-ContainerId($service) {
  $container_id = docker container ls `
    --format "{{.ID}}" `
    -f label=com.khs1994.lnmp `
    -f label=com.docker.compose.service=$service -n 1

  return $container_id
}

Function Invoke-DockerExec($service, $command) {
  $container_id = Get-ContainerId $service
  if (!$container_id) {
    printError "$service" containr not found

    exit 1
  }

  docker exec -it $container_id $command
}

Function clusterkit_bash_cli($env, $service, $command) {
  docker exec -it `
  $( docker container ls `
      --format "{{.ID}}" `
      -f label=com.khs1994.lnmp `
      -f label=com.khs1994.lnmp.app.env=$env `
      -f label=com.docker.compose.service=$service -n 1 ) `
    $command
}

Function satis() {
  if (!(Test-Path ${APP_ROOT}/satis)) {
    cp -Recurse app/satis-demo ${APP_ROOT}/satis
    Write-Warning "Please modify ${APP_ROOT}/satis/satis.json"
  }

  docker run --rm -it `
    -v ${APP_ROOT}/satis:/build `
    --mount -v lnmp_composer-cache-data:/composer composer/satis
}

Function Get-ComposeOptions($compose_files, $isBuild = 0) {
  $COMPOSE_FILE_ARRAY = @()

  Foreach ($compose_file in $compose_files) {
    $COMPOSE_FILE_ARRAY += $compose_file
  }
  Foreach ($item in $LREW_INCLUDE) {
    $KEY = "LREW_$($item -Replace ('-','_'))_VENDOR".ToUpper();
    $content = $(cat $LNMP_ENV_FILE | Where-Object { $_ -like "${KEY}=lrew-dev" })

    # dev
    if (Test-Path $PSScriptRoot/vendor/lrew-dev/$item) {
      $LREW_INCLUDE_ROOT = "$PSScriptRoot/vendor/lrew-dev/$item"
      # set env
      if (!($content)) {
        "${KEY}=lrew-dev" >> $LNMP_ENV_FILE
      }
    }
    elseif (Test-Path $PSScriptRoot/vendor/lrew/$item) {
      $LREW_INCLUDE_ROOT = "$PSScriptRoot/vendor/lrew/$item"
      # unset env
      if ($content) {
        @(Get-Content $LNMP_ENV_FILE) -replace `
          "${KEY}=lrew-dev", '' | Set-Content $LNMP_ENV_FILE
      }
    }
    elseif (Test-Path $PSScriptRoot/lrew/$item) {
      $LREW_INCLUDE_ROOT = "$PSScriptRoot/lrew/$item"
    }
    else {
      continue
    }

    if ($env:USE_WSL2_BUT_DOCKER_NOT_RUNNING -eq '1') {
      printError "Docker not running"
      cd $EXEC_CMD_DIR
      exit 1
    }

    if ($isBuild) {
      if (!(Test-Path "$LREW_INCLUDE_ROOT/docker-compose.build.yml")) {
        $COMPOSE_FILE_ARRAY += "$LREW_INCLUDE_ROOT/docker-compose.yml"
        continue
      }
      $COMPOSE_FILE_ARRAY += "$LREW_INCLUDE_ROOT/docker-compose.yml"
      $COMPOSE_FILE_ARRAY += "$LREW_INCLUDE_ROOT/docker-compose.build.yml"

      continue
    } # end build

    if (!(Test-Path "$LREW_INCLUDE_ROOT/docker-compose.override.yml")) {
      $COMPOSE_FILE_ARRAY += "$LREW_INCLUDE_ROOT/docker-compose.yml"
      continue
    }
    $COMPOSE_FILE_ARRAY += "$LREW_INCLUDE_ROOT/docker-compose.yml"
    $COMPOSE_FILE_ARRAY += "$LREW_INCLUDE_ROOT/docker-compose.override.yml"
  }

  $options += "--env-file $LNMP_ENV_FILE"

  $COMPOSE_FILE_ARRAY += "docker-lnmp.include.yml"
  $COMPOSE_FILE_ARRAY += "docker-workspace.yml"

  if ($env:USE_WSL2_DOCKER_COMPOSE -eq '1') {
    $COMPOSE_FILE_ARRAY_FULL_PATH = @()

    foreach ($item in $COMPOSE_FILE_ARRAY) {
      $COMPOSE_FILE_ARRAY_FULL_PATH += (Get-Item $item).FullName
    }

    $env:COMPOSE_FILE = $COMPOSE_FILE_ARRAY_FULL_PATH -join ';'

    $env:WSLENV = 'COMPOSE_FILE/l'

    #@debug
    # printInfo $(wsl -d ${WSL2_DIST} -- sh -c "echo Load compose files: `$COMPOSE_FILE")
  }
  else {
    $env:COMPOSE_FILE = $COMPOSE_FILE_ARRAY -join ';'
  }

  # write-host $env:COMPOSE_FILE

  if ($env:USE_WSL2_DOCKER_COMPOSE -eq '1') {
    return $options
  }

  return $options.split(' ')
}

Function Test-WSL() {
  wsl -d $DistributionName -- echo ""

  if (!$?) {
    printError "wsl [ $DistributionName ] not found, please check [ $LNMP_ENV_FILE_PS1 ] file `$DistributionName value"
    exit 1
  }
}

function Copy-PCIT() {
  # 判断 app/.pcit 是否存在
  rm -r -force ${APP_ROOT}/.pcit
  # git clone --depth=1 https://github.com/pcit-ce/pcit ${APP_ROOT}/.pcit
  docker pull pcit/pcit:frontend

  docker run -it --rm -v ${APP_ROOT}/.pcit/public:/var/www/pcit/public pcit/pcit:frontend
}

function convert_args_to_string_if_use_wsl2() {
  if ($env:USE_WSL2_DOCKER_COMPOSE -eq '0') {
    return $args
  }

  $string = ""

  foreach ($item in $args) {
    if ($item.getType().Name -eq 'Object[]' ) {
      foreach ($i in $item) {
        $string += " $i "
      }
      continue
    }
    $string += " $item "
  }

  return $string
}

function Edit-Hosts() {
  Start-Process -FilePath "notepad.exe" `
    -ArgumentList "C:\Windows\System32\drivers\etc\hosts" `
    -Verb RunAs
}

# main

# .env .env.ps1
if (Test-Path $PSScriptRoot/.env) {
  printInfo '.env file existing'
}
else {
  Write-Warning '.env file NOT existing, maybe first run'
  cp $PSScriptRoot/.env.example $PSScriptRoot/.env
}

if (Test-Path $PSScriptRoot/.env.ps1) {
  printInfo ".env.ps1 file existing"
}
else {
  Write-Warning ".env.ps1 file NOT existing, maybe first run"
  cp $PSScriptRoot/.env.example.ps1 $PSScriptRoot/.env.ps1
}

# APP_ROOT
$APP_ROOT_CONTENT = (cat $PSScriptRoot/$LNMP_ENV_FILE | select-string ^APP_ROOT=)
if ($APP_ROOT_CONTENT) {
  $APP_ROOT = $APP_ROOT_CONTENT.Line.split('=')[-1]
}
else {
  $APP_ROOT = './app'
}

$env:USE_WSL2_DOCKER_COMPOSE = '0'
$env:USE_WSL2_BUT_DOCKER_NOT_RUNNING = '0'

# 判断项目是否存储在 WSL2

if ($APP_ROOT.Substring(0, 1) -eq '/' -and $WSL2_DIST) {
  $env:USE_WSL2_DOCKER_COMPOSE = '1'

  if (!(Test-Path \\wsl$\ubuntu/mnt/wsl/docker-desktop/cli-tools/usr/bin/docker)) {
    $env:USE_WSL2_BUT_DOCKER_NOT_RUNNING = '1'
  }

  function docker-compose() {
    #@debug
    # printInfo "Exec docker-compose in WSL2 ${WSL2_DIST}: $args"

    $COMPOSE_BIN = "/mnt/wsl/docker-desktop/cli-tools/usr/bin/docker-compose"

    $cmd = convert_args_to_string_if_use_wsl2 $args

    wsl -d $WSL2_DIST -- sh -xc "$COMPOSE_BIN $cmd"
  }
}

if ($APP_ROOT.Substring(0, 1) -eq '/' -and !($WSL2_DIST)) {
  printError "APP_ROOT $APP_ROOT start with '/', but `$WSL2_DIST not set in .env.ps1"

  exit 1
}

# APP_ENV
$APP_ENV_CONTENT = (cat $PSScriptRoot/$LNMP_ENV_FILE | select-string ^APP_ENV=)
if ($APP_ENV_CONTENT) {
  $APP_ENV = $APP_ENV_CONTENT.Line.split('=')[-1]
}
else {
  $APP_ENV = 'development'
}

# cd LNMP_ROOT
if (!(Test-Path cli/khs1994-robot.enc )) {
  # 在项目目录外
  printInfo "Use LNMP CLI in $PWD"
  cd $PSScriptRoot
  if ($APP_ROOT.Substring(0, 1) -eq '/' ) {
    printInfo "APP_ROOT is WSL2 [ $WSL2_DIST ] PATH $APP_ROOT"
  }
  else {
    # cd $PSScriptRoot
    cd $APP_ROOT
    $APP_ROOT = $PWD
    printInfo "APP_ROOT is $APP_ROOT"
  }
  cd $PSScriptRoot
}
else {
  printInfo "Use LNMP CLI in LNMP Root $pwd"
  if ($APP_ROOT.Substring(0, 1) -eq '/' ) {
    printInfo "APP_ROOT is WSL2 [ $WSL2_DIST ] PATH $APP_ROOT"
  }
  else {
    cd $APP_ROOT
    $APP_ROOT = $PWD
    printInfo "APP_ROOT is $APP_ROOT"
  }
  cd $EXEC_CMD_DIR
}

$env:APP_ROOT = $APP_ROOT

# LNMP_SERVICES
$LNMP_SERVICES_CONTENT = (cat $PSScriptRoot/$LNMP_ENV_FILE | select-string ^LNMP_SERVICES=)
if ($LNMP_SERVICES_CONTENT) {
  $LNMP_SERVICES = $LNMP_SERVICES_CONTENT.Line.Split('=')[-1].Trim('"').split(' ')
}
else {
  $LNMP_SERVICES = 'nginx', 'mysql', 'php7', 'redis'
}

# LREW_INCLUDE
$LREW_INCLUDE_CONTENT = (cat $PSScriptRoot/$LNMP_ENV_FILE | select-string ^LREW_INCLUDE=)
if ($LREW_INCLUDE_CONTENT) {
  $LREW_INCLUDE = $LREW_INCLUDE_CONTENT.Line.Split('=')[-1].Trim('"').split(' ')
}
else {
  $LREW_INCLUDE = 'pcit'
}

printInfo "Load lnmp service [ $LNMP_SERVICES ] from [ default $LREW_INCLUDE ]"

if (!(Test-Path lnmp-docker-custom-script.ps1)) {
  Copy-Item lnmp-docker-custom-script.example.ps1 lnmp-docker-custom-script.ps1
}

printInfo "Exec custom script"

. ./lnmp-docker-custom-script.ps1

if (Test-Command docker) {
  $DOCKER_VERSION = $(docker --version).split(' ')[2].split('-')[0].trim(',')
}

$DOCKER_VERSION_YY = ([System.Version]$DOCKER_VERSION).Major
$DOCKER_VERSION_MM = ([System.Version]$DOCKER_VERSION).Minor

if($DOCKER_VERSION_MM -lt 10){
  $DOCKER_VERSION_MM = '0' + $DOCKER_VERSION_MM
}

New-InitFile
New-LogFile
Test-DockerVersion

if (Test-Command docker-compose) {
  printInfo $(docker-compose --version)
}

if ($args.Count -eq 0) {
  help_information
}
else {
  $command, $other = $args
}

switch -regex ($command) {
  lrew-init {
    & $PSScriptRoot/lrew/lrew.ps1 init $other
  }

  lrew-add {
    & $PSScriptRoot/lrew/lrew.ps1 add $other
  }

  lrew-outdated {
    & $PSScriptRoot/lrew/lrew.ps1 outdated $other
  }

  lrew-backup {
    & $PSScriptRoot/lrew/lrew.ps1 backup $other
  }

  lrew-update {
    & $PSScriptRoot/lrew/lrew.ps1 update $other
  }

  httpd-config {
    clear
    Test-WSL
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

  "^build$" {
    $env:USE_WSL2_DOCKER_COMPOSE = '0'

    if ($other) {
      $services = $other
    }
    else {
      $services = ${LNMP_SERVICES}
    }

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.build.yml" `
      1

    Write-Host "Build this service image: $services" -ForegroundColor Green
    sleep 3
    & { docker-compose.exe ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options build $service --parallel }
  }

  build-config {

    New-LogFile

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.build.yml" `
      1

    & { docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options config $other }
  }

  build-up {
    init

    if ($other) {
      $services = $other
    }
    else {
      $services = ${LNMP_SERVICES}
    }

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.build.yml" `
      1

    & { docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options up -d --no-build $services }

    #@custom
    __lnmp_custom_up $services
  }

  build-push {
    $env:USE_WSL2_DOCKER_COMPOSE = '0'

    if ($other) {
      $services = $other
    }
    else {
      $services = ${LNMP_SERVICES}
    }

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.build.yml" `
      1

    Write-Host "Push this service image: $services" -ForegroundColor Green
    sleep 3
    & { docker-compose.exe ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options push $service }
  }

  build-pull {
    $env:USE_WSL2_DOCKER_COMPOSE = '0'

    if ($other) {
      $services = $other
    }
    else {
      $services = ${LNMP_SERVICES}
      if ($services.GetType() -eq [String]) {
        $services = $services.split(' ')
      }
    }

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.build.yml" `
      1

    docker-compose.exe ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options pull $services

    #@custom
    __lnmp_custom_pull
  }

  cleanup {
    cleanup
    #@custom
    __lnmp_custom_cleanup
  }

  "^config$" {
    New-LogFile

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    & { docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options config $other }
  }

  checkout {
    git fetch origin "${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}":"${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}" --depth=1
    git checkout "${DOCKER_VERSION_YY}.${DOCKER_VERSION_MM}"
    _update
  }

  services {
    ${LNMP_SERVICES}
  }

  "^up$" {
    init

    if ($other) {
      $services = $other
    }
    else {
      $services = ${LNMP_SERVICES}
    }

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    & { docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options up --no-build -d $services }

    #@custom
    __lnmp_custom_up $services
  }

  "^pull$" {
    $env:USE_WSL2_DOCKER_COMPOSE = '0'

    if ($other) {
      $services = $other
    }
    else {
      $services = ${LNMP_SERVICES}
      if ($services.GetType() -eq [String]) {
        $services = $services.split(' ')
      }
    }

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    docker-compose.exe ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options pull $services

    #@custom
    __lnmp_custom_pull
  }

  "^down$" {
    $env:USE_WSL2_DOCKER_COMPOSE = '0'

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    docker-compose.exe ${LNMP_COMPOSE_GLOBAL_OPTIONS} down --remove-orphans

    #@custom
    __lnmp_custom_down
  }

  env {
    if ($other) {
      notepad.exe $other
      exit
    }

    notepad.exe $LNMP_ENV_FILE
    notepad.exe $LNMP_ENV_FILE_PS1
  }

  new {
    clear
    Test-WSL
    wsl -d $DistributionName ./lnmp-docker new $other
  }

  nginx-config {
    clear
    Test-WSL
    wsl -d $DistributionName ./lnmp-docker nginx-config $other
  }

  swarm-config {
    docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-production.yml config
  }

  swarm-build {
    docker-compose.exe ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-production.yml build $other --parallel
  }

  swarm-push {
    docker-compose.exe ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-production.yml push $other
  }

  restart {
    $env:USE_WSL2_DOCKER_COMPOSE = '0'

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    & { docker-compose.exe ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options restart $other }
    #@custom
    __lnmp_custom_restart $other
  }

  ssl-self {
    docker run --init -it --rm `
      -v $pwd/config/nginx/ssl-self:/ssl khs1994/tls $other

    printInfo `
      'Import ./config/nginx/ssl-self/root-ca.crt to Browsers,then set hosts in C:\Windows\System32\drivers\etc\hosts'
  }

  satis {
    satis
  }

  "-cli$" {
    $service = ($command).split("-cli")

    if ($other) {
      Invoke-DockerExec $service $other
      exit
    }

    Invoke-DockerExec $service sh
  }

  "^clusterkit$" {
    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml", `
      "cluster/docker-cluster.mysql.yml", `
      "cluster/docker-cluster.redis.yml"

    & { docker-compose.exe ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options up $other }
  }

  clusterkit-mysql-up {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.mysql.yml up $other
  }

  clusterkit-mysql-down {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.mysql.yml down $other
  }

  clusterkit-mysql-config {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.mysql.yml config $other
  }

  clusterkit-mysql-exec {
    $service, $cmd = $other
    if ($cmd.Count -eq 0) {
      '$ ./lnmp-docker.ps1 clusterkit-mysql-exec {master|node-N} {COMMAND}'

      cd $EXEC_CMD_DIR

      exit 1
    }
    clusterkit_bash_cli clusterkit_mysql mysql_$service $cmd
  }

  clusterkit-memcached-up {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.memcached.yml up $other
  }

  clusterkit-memcached-down {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.memcached.yml down $other
  }

  clusterkit-memcached-config {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.memcached.yml config $other
  }

  clusterkit-memcached-exec {
    $service, $cmd = $other
    if ($cmd.Count -eq 0) {
      '$ ./lnmp-docker.ps1 clusterkit-memcached-exec {N} {COMMAND}'

      cd $EXEC_CMD_DIR

      exit 1
    }
    clusterkit_bash_cli clusterkit_memcached memcached-$service $cmd
  }

  clusterkit-redis-up {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.yml up $other
  }

  clusterkit-redis-down {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.yml down $other
  }

  clusterkit-redis-config {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.yml config $other
  }

  clusterkit-redis-exec {
    $service, $cmd = $other
    if ($cmd.Count -eq 0) {
      '$ ./lnmp-docker.ps1 clusterkit-redis-exec {master-N|slave-N} {COMMAND}'

      cd $EXEC_CMD_DIR

      exit 1
    }
    clusterkit_bash_cli clusterkit_redis redis_$service $cmd
  }

  clusterkit-redis-replication-up {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.replication.yml up $other
  }

  clusterkit-redis-replication-down {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.replication.yml down $other
  }

  clusterkit-redis-replication-config {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.replication.yml config $other
  }

  clusterkit-redis-replication-exec {
    $service, $cmd = $other
    if ($cmd.Count -eq 0) {
      '$ ./lnmp-docker.ps1 clusterkit-redis-replication-exec {master|slave-N} {COMMAND}'

      cd $EXEC_CMD_DIR

      exit 1
    }
    clusterkit_bash_cli clusterkit_redis_replication redis_m_s_$service $cmd
  }

  clusterkit-redis-sentinel-up {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.sentinel.yml up $other
  }

  clusterkit-redis-sentinel-down {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.sentinel.yml down $other
  }

  clusterkit-redis-sentinel-config {
    docker-compose.exe --project-directory=$PWD ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f cluster/docker-cluster.redis.sentinel.yml config $other
  }

  clusterkit-redis-sentinel-exec {
    $service, $cmd = $other
    if ($cmd.Count -eq 0) {
      '$ ./lnmp-docker.ps1 clusterkit-redis-sentinel-exec {master-N|slave-N|sentinel-N} {COMMAND}'

      cd $EXEC_CMD_DIR

      exit 1
    }
    clusterkit_bash_cli clusterkit_redis_sentinel redis_sentinel_$service $cmd
  }

  { $_ -in "update", "upgrade" } {
    _update
  }

  { $_ -in "-h", "--help", "help" } {
    help_information
  }

  clusterkit-help {
    clusterkit_help
  }

  bug {
    $os_info = $($psversiontable.BuildVersion)

    if ($os_info.length -eq 0) {
      $os_info = $($psversiontable.os)
    }

    $docker_version = $(docker --version)
    $compose_version = $(docker-compose --version)
    $git_commit = $(git log -1 --pretty=%H)
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
    Start-Process -FilePath "https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61"
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

  pcit-cp {
    Copy-PCIT
  }

  pcit-up {
    Copy-PCIT

    # if (!(Test-Path ${APP_ROOT}/pcit/public/.env.produnction)){
    #   cp ${APP_ROOT}/pcit/public/.env.example ${APP_ROOT}/pcit/public/.env.production
    # }

    if (!(Test-Path pcit/.env.development)) {
      cp pcit/.env.example pcit/.env.development
    }

    # 判断 nginx 配置文件是否存在

    if (!(Test-Path pcit/conf/pcit.conf)) {
      cp pcit/conf/pcit.config pcit/conf/pcit.conf
    }

    $a = Select-String 'demo.ci.khs1994.com' pcit/conf/pcit.conf

    if ($a.Length -ne 0) {
      printError "PCIT nginx conf error, please see pcit/README.md"
    }

    if (!(Test-Path pcit/ssl/ci.crt)) {
      printError "PCIT Website SSL key not found, please see pcit/README.md"
    }

    if (!(Test-Path pcit/key/private.key)) {
      printError "PCIT GitHub App private key not found, please see pcit/README.md"
    }

    if (!(Test-Path pcit/key/public.key)) {
      docker run -it --rm -v $PWD/pcit/key:/app pcit/pcit `
        openssl rsa -in private.key -pubout -out public.key
    }

    cp pcit/ssl/ci.crt config/nginx/ssl/ci.crt

    cp pcit/conf/pcit.conf config/nginx/pcit.conf

    # 启动
    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    & { docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options up -d ${LNMP_SERVICES} pcit }
  }

  daemon-socket {
    try {
      Invoke-WebRequest 127.0.0.1:2376/_ping | out-null

      printInfo "Already run"
    }
    catch {
      docker run -d --restart=always `
        -p 2376:2375 `
        -v /var/run/docker.sock:/var/run/docker.sock `
        -e PORT=2375 `
        --health-cmd="wget 127.0.0.1:2375/_ping -O /proc/self/fd/2" `
        khs1994/docker-proxy
    }
  }

  wait-docker {
    Wait-Docker
  }

  gcr.io {
    printInfo "Check gcr.io host config"

    $GCR_IO_HOST = (ping gcr.io -n 1).split(" ")[9]
    $GCR_IO_HOST_EN = (ping gcr.io -n 1).split(" ")[11].trim(":")

    if (!(($GCR_IO_HOST -eq "127.0.0.1") -or ($GCR_IO_HOST_EN -eq "127.0.0.1"))) {
      printWarning "Please set host on C:\Windows\System32\drivers\etc

127.0.0.1 gcr.io k8s.gcr.io
"

      Edit-Hosts

      exit
    }

    printInfo "gcr.io host config correct"

    if ('logs' -eq $args[1]) {
      docker logs $(docker container ls -f label=com.khs1994.lnmp.gcr.io -q) -f
      exit
    }

    try {
      docker container rm -f `
      $(docker container ls -a -f label=com.khs1994.lnmp.gcr.io -q) > $null 2>&1
    }
    catch {}

    printInfo "This local server support Docker Desktop EDGE v${DOCKER_DESKTOP_VERSION} with Kubernetes v${KUBERNETES_VERSION}"

    if ('down' -eq $args[1]) {
      Write-Warning "Stop gcr.io local server success"
      exit
    }

    mkdir -Force $LNMP_CACHE/registry | out-null

    docker run -it -d `
      -p 443:443 `
      -p 80:80 `
      -v $pwd/config/registry/config.gcr.io.yml:/etc/docker/registry/config.yml `
      -v $pwd/config/registry:/etc/docker/registry/ssl `
      -v $LNMP_CACHE/registry:/var/lib/registry `
      --label com.khs1994.lnmp.gcr.io `
      registry

    # -v $pwd/config/registry/nginx.htpasswd:/etc/docker/registry/auth/nginx.htpasswd `

    if ('--no-pull' -eq $args[1]) {
      printInfo "Up gcr.io Server Success"
      exit
    }

    $images = "kube-controller-manager:v${KUBERNETES_VERSION}", `
      "kube-apiserver:v${KUBERNETES_VERSION}", `
      "kube-scheduler:v${KUBERNETES_VERSION}", `
      "kube-proxy:v${KUBERNETES_VERSION}", `
      "etcd:3.4.13-0", `
      "coredns:1.7.0", `
      "pause:3.2", `
      "pause:3.1"

    sleep 10

    function Test-GcrImage([string] $image) {
      if ($(docker image ls -q k8s.gcr.io/$image)) {
        return $true
      }

      return $false
    }

    function Get-GcrImage([string] $image, [string] $mirror) {
      docker pull $mirror/$image
      docker tag  $mirror/$image k8s.gcr.io/$image
      # docker push k8s.gcr.io/$image
      docker rmi  $mirror/$image
    }

    # $ErrorActionPreference="SilentlyContinue"

    foreach ($image in $images) {
      printInfo "Handle ${image} ..."

      if (Test-GcrImage $image) {
        printInfo "k8s.gcr.io/$image exists"

        continue;
      }

      Get-GcrImage $image "gcr.io/google_containers"

      if (Test-GcrImage $image) {
        continue;
      }

      # 一些镜像 aliyun 可能不存在，从第二个镜像下载

      printError "Download from mirror error, try other mirror"

      Get-GcrImage $image "ccr.ccs.tencentyun.com/gcr-mirror"
    }

    try {
      docker container rm -f `
      $(docker container ls -a -f label=com.khs1994.lnmp.gcr.io -q) > $null 2>&1
    }
    catch {}
  }

  composer {
    if ((Test-Path $EXEC_CMD_DIR/.devcontainer) -And (Test-Path $EXEC_CMD_DIR/docker-workspace.yml)) {
      printInfo "Exec composer command in [ vscode remote ] or [ PhpStorm ] project folder"
      cd $EXEC_CMD_DIR
      docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-workspace.yml run --rm composer $args

      exit
    }

    $WORKING_DIR, $COMPOSER_COMMAND = $other

    if (!$WORKING_DIR) {
      "Some ARGs require

Usage: ./lnmp-docker composer PATH_IN_CONTAINER COMPOSER_COMMAND

Example: ./lnmp-docker composer /app/demo install
"

      exit 1
    }

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    & { docker-compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options run -w $WORKING_DIR --rm composer $COMPOSER_COMMAND }
  }

  hosts {
    Edit-Hosts
  }

  dockerd {
    & $PSScriptRoot/wsl2/bin/dockerd-wsl2.ps1 $other
  }

  "compose$" {
    $DIST = "C:\ProgramData\DockerDesktop\version-bin\docker-compose.exe"
    if ($other) {
      $DIST = $other

      if ($other.count -gt 1) {
        $DIST = $other[0]
      }
    }

    printInfo "Download docker-compose $LNMP_DOCKER_COMPOSE_VERSION to $DIST ..."

    start-process "curl.exe" -ArgumentList "-L", "https://github.com/docker/compose/releases/download/${LNMP_DOCKER_COMPOSE_VERSION}/docker-compose-Windows-x86_64.exe", "-o", "$DIST" -Verb Runas -wait -WindowStyle Hidden
  }

  "^code-init$" {
    cd $EXEC_CMD_DIR

    Copy-Item -r $PSScriptRoot/vscode-remote/*

    printInfo "vsCode remote project init success"
  }

  "^code-run$" {
    cd $EXEC_CMD_DIR

    docker-compose -f docker-workspace.yml run --rm $other
  }

  "^code-exec$" {
    cd $EXEC_CMD_DIR

    docker-compose -f docker-workspace.yml exec $other
  }

  "mount" {
    if (!$WSL2_DIST) {
      $WSL2_DIST = 'ubuntu'
    }

    function _get_dev_sdx($type = "ext4") {
      $dev_sdx = wsl -d $WSL2_DIST -- mount -t $type `| grep PHYSICALDRIVE `| cut -d ' ' -f 1

      return $dev_sdx
    }

    printInfo "try mount physical disk to WSL2 $WSL2_DIST"
    wsl -d $WSL2_DIST -u root -- sh -c "mountpoint -q /app"

    if ($?) {
      printInfo "$WSL2_DIST /app already mount"

      exit
    }

    if (!($MountPhysicalDiskDeviceID2WSL2 -and $MountPhysicalDiskPartitions2WSL2)) {
      printError "please set `$MountPhysicalDiskDeviceID2WSL2 and `$MountPhysicalDiskPartitions2WSL2 in .env.ps1"

      exit 1
    }

    if (!$MountPhysicalDiskType2WSL2) {
      $MountPhysicalDiskType2WSL2 = "ext4"
    }

    $dev_sdx = _get_dev_sdx $MountPhysicalDiskType2WSL2

    if (!$dev_sdx) {
      printInfo "physical disk not mount, I will exec $ wsl --mount ..."
      start-process "wsl" `
        -ArgumentList "--mount", "$MountPhysicalDiskDeviceID2WSL2", "--partition", "$MountPhysicalDiskPartitions2WSL2" `
        -Verb runAs

      sleep 2

      $dev_sdx = _get_dev_sdx $MountPhysicalDiskType2WSL2
    }
    else {
      printInfo "physical disk already mount to $dev_sdx, I will mount $dev_sdx to /app"
    }

    if (!$dev_sdx) {
      printError "please re-exec"

      exit 1
    }

    wsl -d $WSL2_DIST -u root -- sh -cx "mkdir -p /app"
    wsl -d $WSL2_DIST -u root -- sh -cx "chown 1000:1000 /app"
    wsl -d $WSL2_DIST -u root -- sh -cx "mount $dev_sdx /app"
  }

  "^code$" {
    if ($env:USE_WSL2_DOCKER_COMPOSE -eq '0') {
      printError "APP_ROOT is not in WSL2, exit"

      exit 1
    }

    if ($other) {
      foreach ($path in $other) {
        if ($path.substring(0, 1) -eq '/') {
          # 不支持打开任意目录，只支持打开 $APP_ROOT 或其子目录
          $path = $path.substring(1)
        }

        wsl -d $WSL2_DIST -u root -- test -d $APP_ROOT/$path
        if (!$?) {
          # 不是 dir
          printError WSL2 $WSL2_DIST [ ${APP_ROOT}/${path} ] `
            is not`'t a dir`, [ ${APP_ROOT} ] include this dir:

          write-host `n
          wsl -d $WSL2_DIST -u root -- ls -la $APP_ROOT

          write-host `n`n

          exit
        }
        printInfo Open WSL2 $WSL2_DIST [ $APP_ROOT/$path ]
        code --remote wsl+$WSL2_DIST $APP_ROOT/$path

        cd $EXEC_CMD_DIR

        exit
      }
    }
    printInfo Open WSL2 $WSL2_DIST [ $APP_ROOT ]
    code --remote wsl+$WSL2_DIST $APP_ROOT
  }

  default {
    #@custom
    __lnmp_custom_command $args
    printInfo `
      "maybe you input command is notdefined, I will try exec $ docker-compose CMD"
    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    $command, $other = $args
    & { docker-compose $options $command $other }
  }
}

cd $EXEC_CMD_DIR
