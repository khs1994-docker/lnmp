
<#PSScriptInfo

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
    git clone -b 23.11 --depth=1 https://github.com/khs1994-docker/lnmp.git $home\lnmp

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

if (!(Test-Path $PSScriptRoot\scripts\cli\khs1994-robot.enc )) {
  Write-Host "lnmp-docker.ps1 not in lnmp ROOT PATH" -ForegroundColor Red

  Write-Host "Please remove $((get-command lnmp-docker).Source)" -ForegroundColor Red

  exit 1
}

printInfo "Load env file [ $LNMP_ENV_FILE ] and [ $LNMP_ENV_FILE_PS1 ]"

. "$PSScriptRoot/.env.example.ps1"

. "$PSScriptRoot/scripts/cli/.env.ps1"

if (Test-Path "$PSScriptRoot/$LNMP_ENV_FILE_PS1") {
  . "$PSScriptRoot/$LNMP_ENV_FILE_PS1"
}

# [environment]::SetEnvironmentvariable("DOCKER_DEFAULT_PLATFORM", "linux", "User");

# $ErrorActionPreference="SilentlyContinue"
# Stop, Continue, Inquire, Ignore, Suspend, Break

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
  if (Test-Path docker-lnmp.include.yml) {
    Copy-Item docker-lnmp.include.yml docker-lnmp.override.yml
    Copy-Item docker-lnmp.include.yml docker-lnmp.include.yml.backup
    Remove-Item -r -force docker-lnmp.include.yml
  }

  _cp_only_not_exists kubernetes/nfs-server/.env.example kubernetes/nfs-server/.env

  _cp_only_not_exists config/supervisord/supervisord.ini.example config/supervisord/supervisord.ini

  if (!(Test-Path secrets/minio/root-password.txt)) {
    Copy-Item secrets/minio/root-password.example.txt secrets/minio/root-password.txt
    Copy-Item secrets/minio/root-user.example.txt secrets/minio/root-user.txt
  }

  if (!(Test-Path config/redis/redis.conf)) {
    New-Item -ItemType File config/redis/redis.conf
  }

  if (!(Test-Path config/mysql/conf.d/my.cnf)) {
    New-Item -ItemType File config/mysql/conf.d/my.cnf
  }

  if (!(Test-Path config/mariadb/conf.d/my.cnf)) {
    New-Item -ItemType File config/mariadb/conf.d/my.cnf
  }

  _cp_only_not_exists docker-lnmp.override.example.yml docker-lnmp.override.yml

  _cp_only_not_exists docker-workspace.example.yml docker-workspace.yml

  _cp_only_not_exists config/php/docker-php.example.ini config/php/docker-php.ini
  _cp_only_not_exists config/php/php.development.ini config/php/php.ini
  _cp_only_not_exists config/php/php-cli.example.ini config/php/php-cli.ini
  _cp_only_not_exists config/php/zz-docker.example.conf config/php/zz-docker.conf
  _cp_only_not_exists config/php8/docker-php.example.ini config/php8/docker-php.ini
  _cp_only_not_exists config/php8/php.development.ini config/php8/php.ini
  _cp_only_not_exists config/php8/php-cli.example.ini config/php8/php-cli.ini
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

Function init() {
  New-LogFile
  # git submodule update --init --recursive
  printInfo 'Init success'
  #@custom
  __lnmp_custom_init
}

Function help_information() {
  "Docker-LNMP CLI ${LNMP_VERSION}

Official WebSite https://lnmp.khs1994.com

Usage: ./docker-lnmp COMMAND

Donate:
  zan                  Donate

Commands:
  up                   Up LNMP (Support x86_64 arm64v8)
  down                 Stop and remove LNMP Docker containers, networks, images, and volumes
  backup               Backup MySQL databases
  build                Build or rebuild your LNMP Docker Images (Only Support x86_64)
  push                 Pushes LNMP Docker Images to Docker Registory
  pull                 Pull LNMP Docker Images
  cleanup              Cleanup log files
  config               Validate and view the LNMP Compose file
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
  mount                Attaches and mounts a physical disk in all WSL2 distributions.(please exec this command before docker desktop running)

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

Swarm mode:
  swarm-build          Build Swarm image (nginx php7)
  swarm-config         Validate and view the Production Swarm mode Compose file
  swarm-push           Push Swarm image (nginx php7)

Container Tools:
  SERVICE-cli          Execute a command in a running LNMP container

Developer Tools:

Read './docs/*.md' for more information about CLI commands.

You can open issue in [ https://github.com/khs1994-docker/lnmp/issues ] when you meet problems.

You must Update .env file when update this project.

Exec '$ lnmp-docker zan' donate
"

  cd $EXEC_CMD_DIR

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
  git fetch origin ${BRANCH}:lnmp-temp/${BRANCH}
  git reset --hard lnmp-temp/${BRANCH}
  git branch -D lnmp-temp/${BRANCH}
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

Function satis() {
  if (!(Test-Path ${APP_ROOT}/satis)) {
    cp -Recurse app/satis-demo ${APP_ROOT}/satis
    Write-Warning "Please modify ${APP_ROOT}/satis/satis.json"
  }

  docker run --rm -it `
    -v ${APP_ROOT}/satis:/build `
    --mount -v lnmp_composer-cache-data:/composer composer/satis
}

Function Get-ComposeOptions($compose_files) {
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

    $COMPOSE_FILE_ARRAY += "$LREW_INCLUDE_ROOT/docker-compose.yml"

    if (Test-Path "$LREW_INCLUDE_ROOT/docker-compose.override.yml") {
      $COMPOSE_FILE_ARRAY += "$LREW_INCLUDE_ROOT/docker-compose.override.yml"
    }
  }

  $options += "--env-file $LNMP_ENV_FILE"

  $COMPOSE_FILE_ARRAY += "docker-workspace.yml"

  $env:COMPOSE_FILE = $COMPOSE_FILE_ARRAY -join ';'

  # write-host $env:COMPOSE_FILE

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

function Get-Env($ENV_NAME, $ENV_FILE, $ENV_DEFAULT) {
  $ENV_CONTENT = (cat $PSScriptRoot/${ENV_FILE} | select-string ^$ENV_NAME=)
  if ($ENV_CONTENT) {
    if ($ENV_CONTENT.Line.GetType().FullName -eq 'System.String') {
      return $ENV_CONTENT.Line.split('=')[-1]
    }
    else {
      return $ENV_CONTENT.Line[-1].split('=')[-1]
    }
  }

  return $ENV_DEFAULT
}

# APP_ROOT
$APP_ROOT = Get-Env 'APP_ROOT' $LNMP_ENV_FILE './app'

$env:USE_WSL2_BUT_DOCKER_NOT_RUNNING = '3'

if (($APP_ROOT.length -gt 7) -and ($APP_ROOT.Substring(0, 7) -eq '\\wsl$\')) {
  $env:USE_WSL2_BUT_DOCKER_NOT_RUNNING = '0'

  $WSL2_DIST = $APP_ROOT.Split('\')[3]

  if ($APP_ROOT.length -le (8 + $WSL2_DIST.length)) {
    printError "please check APP_ROOT value in .env file"

    exit 1
  }

  $WSL2_DIST_PATH = '/' + $APP_ROOT.Substring(8 + $WSL2_DIST.length)

  if ($WSL2_DIST_PATH.Length -eq 1) {
    printError "please check APP_ROOT value in .env file"

    exit 1
  }

  if (!(Test-Path \\wsl$\$WSL2_DIST/mnt/wsl/docker-desktop/cli-tools/usr/bin/docker)) {
    $env:USE_WSL2_BUT_DOCKER_NOT_RUNNING = '1'
  }
}

# APP_ENV

$APP_ENV = Get-Env -ENV_NAME 'APP_ENV' -ENV_FILE $LNMP_ENV_FILE -ENV_DEFAULT 'development'

# cd LNMP_ROOT
if (!(Test-Path scripts/cli/khs1994-robot.enc )) {
  # 在项目目录外
  printInfo "Use LNMP CLI in $PWD"
  cd $PSScriptRoot
  if (($APP_ROOT.length -gt 7) -and ($APP_ROOT.Substring(0, 7) -eq '\\wsl$\')) {
    printInfo "APP_ROOT is WSL2 [ $WSL2_DIST ] PATH $WSL2_DIST_PATH"
  }
  else {
    # cd $PSScriptRoot
    if (!(Test-Path $APP_ROOT)) {
      New-Item -ItemType Directory -Force $APP_ROOT | Out-Null
    }
    cd $APP_ROOT
    $APP_ROOT = $PWD
    printInfo "APP_ROOT is $APP_ROOT"
  }
  cd $PSScriptRoot
}
else {
  printInfo "Use LNMP CLI in LNMP Root $pwd"
  if (($APP_ROOT.length -gt 7) -and ($APP_ROOT.Substring(0, 7) -eq '\\wsl$\')) {
    printInfo "APP_ROOT is WSL2 [ $WSL2_DIST ] PATH $WSL2_DIST_PATH"
  }
  else {
    if (!(Test-Path $APP_ROOT)) {
      New-Item -ItemType Directory -Force $APP_ROOT | Out-Null
    }
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
  $LNMP_SERVICES = 'nginx', 'mysql', 'php8', 'redis'
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

. ./lnmp-docker-custom-script.example.ps1
. ./lnmp-docker-custom-script.ps1

New-InitFile
New-LogFile

docker compose version | out-null

if (!($?)) {
  printError "Docker Compose V2 not found, please install, see https://docs.docker.com/compose/install/compose-plugin/"
  exit 1
}

if (!((docker compose version).split( )[-1].trim('v') -ge $REQUIRE_DOCKER_COMPOSE_VERSION)) {
  printError "your compose version is not ge v$REQUIRE_DOCKER_COMPOSE_VERSION"

  exit 1
}

printInfo $(docker compose version)

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
    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} exec mysql /backup/backup.sh $other
    #@custom
    __lnmp_custom_backup $other
  }

  restore {
    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} exec mysql /backup/restore.sh $other
    #@custom
    __lnmp_custom_restore $other
  }

  "^build$" {
    if ($other) {
      $services = $other
    }
    else {
      $services = ${LNMP_SERVICES}
    }

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    Write-Host "Build this service image: $services" -ForegroundColor Green
    sleep 3
    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options build $service
  }

  push {
    if ($other) {
      $services = $other
    }
    else {
      $services = ${LNMP_SERVICES}
    }

    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    Write-Host "Push this service image: $services" -ForegroundColor Green
    sleep 3
    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options push $service
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

    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options config $other
  }

  checkout {
    git fetch origin 23.11:23.11 --depth=1
    git checkout 23.11
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

    #@custom
    __lnmp_custom_pre_up $services

    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options config > compose-up.yaml
    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options up --no-build -d $services

    #@custom
    __lnmp_custom_post_up $services
  }

  "^pull$" {
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

    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options pull $services

    #@custom
    __lnmp_custom_post_pull
  }

  "^down$" {
    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} down --remove-orphans

    #@custom
    __lnmp_custom_post_down
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
    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-production.yml config
  }

  swarm-build {
    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-production.yml build $other
  }

  swarm-push {
    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-production.yml push $other
  }

  restart {
    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options restart $other
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

  { $_ -in "update", "upgrade" } {
    _update
  }

  { $_ -in "-h", "--help", "help" } {
    help_information
  }

  bug {
    $os_info = $($psversiontable.BuildVersion)

    if ($os_info.length -eq 0) {
      $os_info = $($psversiontable.os)
    }

    $docker_version = $(docker --version)
    $compose_version = $(docker compose version)
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

  zan {
    clear
    printInfo "Thank You"
    Start-Process -FilePath https://zan.khs1994.com
  }

  donate {
    clear
    printInfo "Thank You"
    Start-Process -FilePath https://zan.khs1994.com
  }

  fund {
    clear
    printInfo "Thank You"
    Start-Process -FilePath https://zan.khs1994.com
  }

  pcit-cp {
    Copy-PCIT
  }

  pcit-up {
    Copy-PCIT

    # if (!(Test-Path ${APP_ROOT}/pcit/public/.env.produnction)){
    #   cp ${APP_ROOT}/pcit/public/.env.example ${APP_ROOT}/pcit/public/.env.production
    # }

    if (!(Test-Path lrew/pcit/.env.development)) {
      cp lrew/pcit/.env.example lrew/pcit/.env.development
    }

    # 判断 nginx 配置文件是否存在

    if (!(Test-Path lrew/pcit/conf/pcit.conf)) {
      cp lrew/pcit/conf/pcit.config lrew/pcit/conf/pcit.conf
    }

    $a = Select-String 'demo.ci.khs1994.com' lrew/pcit/conf/pcit.conf

    if ($a.Length -ne 0) {
      printError "PCIT nginx conf error, please see lrew/pcit/README.md"
    }

    if (!(Test-Path lrew/pcit/ssl/ci.crt)) {
      printError "PCIT Website SSL key not found, please see lrew/pcit/README.md"
    }

    if (!(Test-Path lrew/pcit/key/private.key)) {
      printError "PCIT GitHub App private key not found, please see lrew/pcit/README.md"
    }

    if (!(Test-Path lrew/pcit/key/public.key)) {
      docker run -it --rm -v $PWD/lrew/pcit/key:/app pcit/pcit `
        openssl rsa -in private.key -pubout -out public.key
    }

    cp lrew/pcit/ssl/ci.crt config/nginx/ssl/ci.crt

    cp lrew/pcit/conf/pcit.conf config/nginx/pcit.conf

    # 启动
    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options up -d ${LNMP_SERVICES} pcit
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

  composer {
    if ((Test-Path $EXEC_CMD_DIR/.devcontainer) -And (Test-Path $EXEC_CMD_DIR/docker-workspace.yml)) {
      printInfo "Exec composer command in [ vscode remote ] or [ PhpStorm ] project folder"
      cd $EXEC_CMD_DIR
      docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} -f docker-workspace.yml run --rm composer $args

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

    docker compose ${LNMP_COMPOSE_GLOBAL_OPTIONS} $options run -w $WORKING_DIR --rm composer $COMPOSER_COMMAND
  }

  hosts {
    Edit-Hosts
  }

  "^code-init$" {
    cd $EXEC_CMD_DIR

    Copy-Item -r $PSScriptRoot/vscode-remote/*

    printInfo "vsCode remote project init success"
  }

  "^code-run$" {
    cd $EXEC_CMD_DIR

    docker compose -f docker-workspace.yml run --rm $other
  }

  "^code-exec$" {
    cd $EXEC_CMD_DIR

    docker compose -f docker-workspace.yml exec $other
  }

  "mount" {
    if ($env:USE_WSL2_BUT_DOCKER_NOT_RUNNING -eq '0') {
      printError "Docker is running"
      printError "Please run [ ./lnmp-docker mount ] before docker start"

      exit 1
    }

    if (!$WSL2_DIST) {
      $WSL2_DIST = 'ubuntu'
    }

    function Get-wsl2_mount_physicaldiskdevice_dev_sdx($type = "ext4") {
      $dev_sdx = wsl -d $WSL2_DIST -- mount -t $type `| grep PHYSICALDRIVE `| cut -d ' ' -f 1

      return $dev_sdx
    }

    function Get-wsl2_mount_physicaldiskdevice_path($type = "ext4") {
      $wsl2_mount_physicaldiskdevice_path = wsl -d $WSL2_DIST -- mount -t $type `| grep PHYSICALDRIVE `| cut -d ' ' -f 3

      return $wsl2_mount_physicaldiskdevice_path
    }

    printInfo "try mount physical disk to WSL2 [ $WSL2_DIST ]"
    wsl -d $WSL2_DIST -u root -- sh -c "mountpoint -q $WSL2_DIST_PATH"

    if ($?) {
      printInfo "$WSL2_DIST $WSL2_DIST_PATH already mount"

      exit
    }

    if (!($MountPhysicalDiskDeviceID2WSL2 -and $MountPhysicalDiskPartitions2WSL2)) {
      printError "please set `$MountPhysicalDiskDeviceID2WSL2 and `$MountPhysicalDiskPartitions2WSL2 in .env.ps1"

      exit 1
    }

    if (!$MountPhysicalDiskType2WSL2) {
      $MountPhysicalDiskType2WSL2 = "ext4"
    }

    $dev_sdx = Get-wsl2_mount_physicaldiskdevice_dev_sdx $MountPhysicalDiskType2WSL2

    if (!$dev_sdx) {
      printInfo "physical disk not mount, I will exec $ wsl --mount ..."
      start-process "wsl" `
        -ArgumentList "--mount", "$MountPhysicalDiskDeviceID2WSL2", "--partition", "$MountPhysicalDiskPartitions2WSL2" `
        -Verb runAs

      sleep 2

      $dev_sdx = Get-wsl2_mount_physicaldiskdevice_dev_sdx $MountPhysicalDiskType2WSL2
    }
    else {
      printInfo "physical disk already mount to $dev_sdx, I will mount $dev_sdx to $WSL2_DIST_PATH"
    }

    if (!$dev_sdx) {
      printError 'please re-exec, or check $MountPhysicalDiskDeviceID2WSL2 and $MountPhysicalDiskPartitions2WSL2 in .env.ps1'

      exit 1
    }

    $wsl2_mount_physicaldiskdevice_path = Get-wsl2_mount_physicaldiskdevice_path $MountPhysicalDiskType2WSL2

    & $PSScriptRoot/kubernetes/wsl2/bin/wsl2d.ps1 $WSL2_DIST
    wsl -d $WSL2_DIST -u root -- sh -cx "mkdir -p $WSL2_DIST_PATH"
    wsl -d $WSL2_DIST -u root -- sh -cx "mkdir -p ${wsl2_mount_physicaldiskdevice_path}${WSL2_DIST_PATH}"
    wsl -d $WSL2_DIST -u root -- sh -cx "mount --bind ${wsl2_mount_physicaldiskdevice_path}${WSL2_DIST_PATH} $WSL2_DIST_PATH"
    wsl -d $WSL2_DIST -u root -- sh -cx "chown 1000:1000 $WSL2_DIST_PATH"
    $WSL2_DIST_USER=$(wsl -d ubuntu-22.04 -- sh -c 'echo $USER')

    wsl -d $WSL2_DIST -u root -- sh -cx "mkdir -p /home/$WSL2_DIST_USER/.cache/JetBrains"
    wsl -d $WSL2_DIST -u root -- sh -cx "mkdir -p ${wsl2_mount_physicaldiskdevice_path}/home/$WSL2_DIST_USER/.cache/JetBrains"
    wsl -d $WSL2_DIST -u root -- sh -cx "chown -R ${WSL2_DIST_USER}:${WSL2_DIST_USER} /home/$WSL2_DIST_USER/.cache/JetBrains"
    wsl -d $WSL2_DIST -u root -- sh -cx "chown -R ${WSL2_DIST_USER}:${WSL2_DIST_USER} ${wsl2_mount_physicaldiskdevice_path}/home/$WSL2_DIST_USER/.cache/JetBrains"
    wsl -d $WSL2_DIST -u root -- sh -cx "mount --bind ${wsl2_mount_physicaldiskdevice_path}/home/$WSL2_DIST_USER/.cache/JetBrains /home/$WSL2_DIST_USER/.cache/JetBrains"

    wsl -d $WSL2_DIST -u root -- sh -cx "mkdir -p /home/$WSL2_DIST_USER/.vscode-server"
    wsl -d $WSL2_DIST -u root -- sh -cx "mkdir -p ${wsl2_mount_physicaldiskdevice_path}/home/$WSL2_DIST_USER/.vscode-server"
    wsl -d $WSL2_DIST -u root -- sh -cx "chown -R ${WSL2_DIST_USER}:${WSL2_DIST_USER} /home/$WSL2_DIST_USER/.vscode-server"
    wsl -d $WSL2_DIST -u root -- sh -cx "chown -R ${WSL2_DIST_USER}:${WSL2_DIST_USER} ${wsl2_mount_physicaldiskdevice_path}/home/$WSL2_DIST_USER/.vscode-server"
    wsl -d $WSL2_DIST -u root -- sh -cx "mount --bind ${wsl2_mount_physicaldiskdevice_path}/home/$WSL2_DIST_USER/.vscode-server /home/$WSL2_DIST_USER/.vscode-server"
  }

  "^code$" {
    if ($env:USE_WSL2_BUT_DOCKER_NOT_RUNNING -eq '3') {
      printError "APP_ROOT is not WSL2 dir"

      exit 1
    }

    if ($other) {
      foreach ($path in $other) {
        if ($path.substring(0, 1) -eq '/') {
          # 不支持打开任意目录，只支持打开 $APP_ROOT 或其子目录
          $path = $path.substring(1)
        }

        wsl -d $WSL2_DIST -u root -- test -d $WSL2_DIST_PATH/$path
        if (!$?) {
          # 不是 dir
          printError WSL2 $WSL2_DIST [ $WSL2_DIST_PATH/${path} ] `
            is not`'t a dir`, [ $WSL2_DIST_PATH ] include this dir:

          write-host `n
          wsl -d $WSL2_DIST -u root -- ls -la $WSL2_DIST_PATH

          write-host `n`n

          exit 1
        }
        printInfo Open WSL2 $WSL2_DIST [ $WSL2_DIST_PATH/$path ]
        code --remote wsl+$WSL2_DIST $WSL2_DIST_PATH/$path

        cd $EXEC_CMD_DIR

        exit
      }
    }
    printInfo Open WSL2 $WSL2_DIST [ $WSL2_DIST_PATH ]
    code --remote wsl+$WSL2_DIST $WSL2_DIST_PATH
  }

  outdated {
    "[
    {
      `"SOFT_NAME`":`"nginx`",
      `"CURRENT_VERSION`":`"$(Get-Env LNMP_NGINX_VERSION $LNMP_ENV_FILE '')`",
      `"LATEST_VERSION`":`"$(Get-Env LNMP_NGINX_VERSION '.env.example' '')`"
    },
    {
      `"SOFT_NAME`":`"MySQL`",
      `"CURRENT_VERSION`":`"$(Get-Env LNMP_MYSQL_VERSION $LNMP_ENV_FILE '')`",
      `"LATEST_VERSION`":`"$(Get-Env LNMP_MYSQL_VERSION '.env.example' '')`"
    },
    {
      `"SOFT_NAME`":`"PHP`",
      `"CURRENT_VERSION`":`"$(Get-Env LNMP_PHP_VERSION $LNMP_ENV_FILE '')`",
      `"LATEST_VERSION`":`"$(Get-Env LNMP_PHP_VERSION '.env.example' '')`"
    },
    {
      `"SOFT_NAME`":`"PHP82`",
      `"CURRENT_VERSION`":`"$(Get-Env LNMP_PHP82_VERSION $LNMP_ENV_FILE '')`",
      `"LATEST_VERSION`":`"$(Get-Env LNMP_PHP82_VERSION '.env.example' '')`"
    },
    {
      `"SOFT_NAME`":`"PHP80`",
      `"CURRENT_VERSION`":`"$(Get-Env LNMP_PHP80_VERSION $LNMP_ENV_FILE '')`",
      `"LATEST_VERSION`":`"$(Get-Env LNMP_PHP80_VERSION '.env.example' '')`"
    },
    {
      `"SOFT_NAME`":`"PHP74`",
      `"CURRENT_VERSION`":`"$(Get-Env LNMP_PHP74_VERSION $LNMP_ENV_FILE '')`",
      `"LATEST_VERSION`":`"$(Get-Env LNMP_PHP74_VERSION '.env.example' '')`"
    },
    {
      `"SOFT_NAME`":`"Redis`",
      `"CURRENT_VERSION`":`"$(Get-Env LNMP_REDIS_VERSION $LNMP_ENV_FILE '')`",
      `"LATEST_VERSION`":`"$(Get-Env LNMP_REDIS_VERSION '.env.example' '')`"
    },
    {
      `"SOFT_NAME`":`"Node.js`",
      `"CURRENT_VERSION`":`"$(Get-Env LNMP_NODE_VERSION $LNMP_ENV_FILE '')`",
      `"LATEST_VERSION`":`"$(Get-Env LNMP_NODE_VERSION '.env.example' '')`"
    },
    {
      `"SOFT_NAME`":`"PHPMyAdmin`",
      `"CURRENT_VERSION`":`"$(Get-Env LNMP_PHPMYADMIN_VERSION $LNMP_ENV_FILE '')`",
      `"LATEST_VERSION`":`"$(Get-Env LNMP_PHPMYADMIN_VERSION '.env.example' '')`"
    },
    {
      `"SOFT_NAME`":`"Memcached`",
      `"CURRENT_VERSION`":`"$(Get-Env LNMP_MEMCACHED_VERSION $LNMP_ENV_FILE '')`",
      `"LATEST_VERSION`":`"$(Get-Env LNMP_MEMCACHED_VERSION '.env.example' '')`"
    },
   ]" | ConvertFrom-Json

  }

  default {
    #@custom
    __lnmp_custom_command $args
    printInfo `
      "maybe you input command is notdefined, I will try exec $ docker compose CMD"
    $options = Get-ComposeOptions "docker-lnmp.yml", `
      "docker-lnmp.override.yml"

    $command, $other = $args
    docker compose $options $command $other
  }
}

cd $EXEC_CMD_DIR
