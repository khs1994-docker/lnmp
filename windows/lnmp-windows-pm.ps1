#
# $ set-ExecutionPolicy RemoteSigned
#

# 大于 -gt (greater than)
# 小于 -lt (less than)
# 大于或等于 -ge (greater than or equal)
# 小于或等于 -le (less than or equal)
# 不相等 -ne （not equal）
# 等于 -eq

Function print_help_info(){
  "
LNMP Windows Package Manager

COMMANDS:

install     Install soft [--pre| ]
uninstall   Uninstall soft [--prune| ]
remove      Uninstall soft
list        List available softs
outdated    Shows a list of installed packages that have updates available
info        Shows information about packages
homepage    Opens the package's repository URL or homepage in your browser
bug         Opens the package's bug report page in your browser
releases    Opens the package's releases page in your browser
help        Print help info

add         Add package
init        Init a new package(developer)
"
}

$ErrorAction="SilentlyContinue"

. "$PSScriptRoot/common.ps1"

$source=$PWD

# 配置环境变量
$LNMP_PATH="$HOME\lnmp"
[environment]::SetEnvironmentvariable("DOCKER_CLI_EXPERIMENTAL", "enabled", "User")
[environment]::SetEnvironmentvariable("DOCKER_BUILDKIT", "1", "User")
[environment]::SetEnvironmentvariable("LNMP_PATH", "$LNMP_PATH", "User")
[environment]::SetEnvironmentvariable("APP_ENV", "$APP_ENV", "User")

$LNMP_PATH = [environment]::GetEnvironmentvariable("LNMP_PATH", "User")

$Env:PSModulePath="$Env:PSModulePath" + ";" `
                  + $PSScriptRoot + "\powershell_system" + ";"

_exportPath "$LNMP_PATH","$LNMP_PATH\windows","$LNMP_PATH\wsl", `
       "$LNMP_PATH\kubernetes", `
       "$LNMP_PATH\kubernetes\coreos",`
       "$env:USERPROFILE\app\pcit\bin", `
       "C:\bin"

$env:path=[environment]::GetEnvironmentvariable("Path","user") `
          + ';' + [environment]::GetEnvironmentvariable("Path","machine") `
          + ';' + [environment]::GetEnvironmentvariable("Path","process")

Function _rename($src,$target){
  if (!(Test-Path $target)){
  Rename-Item $src $target
  }
}

Function _echo_line(){
  Write-Host "


"
}

Function _installer($zip, $unzip_path, $unzip_folder_name = 'null', $soft_path = 'null'){
  if (Test-Path $soft_path){
    Write-Host "==> $unzip_folder_name already installed" -ForegroundColor Green
    _echo_line
    return
  }

  Write-Host "==> $unzip_folder_name installing ..." -ForegroundColor Red

  if (!(Test-Path $unzip_folder_name)){
    _unzip $zip $unzip_path
  }

  if (!($soft_path -eq 'null')){
    _rename $unzip_folder_name $soft_path
  }

}

################################################################################

_mkdir C:\bin

_mkdir $home\Downloads\lnmp-docker-cache

_mkdir $home\lnmp\windows\logs

cd $home\Downloads\lnmp-docker-cache

if($args.length -eq 0 -or $args[0] -eq '--help' -or $args[0] -eq '-h' -or $args[0] -eq 'help'){
  $_, $softs = $args
  print_help_info
  cd $source
  exit
}

################################################################################

Function _import_module($soft){
  if(Test-Path "${PSScriptRoot}\lnmp-windows-pm-repo\$soft"){
    Import-Module -Name "${PSScriptRoot}\lnmp-windows-pm-repo\$soft"
  }elseif (Test-Path "${PSScriptRoot}\..\vendor\lwpm-dev\$soft"){
    "==> vendor dev"
    Import-Module -Name "${PSScriptRoot}\..\vendor\lwpm-dev\$soft"
  }elseif (Test-Path "${PSScriptRoot}\..\vendor\lwpm\$soft"){
    Import-Module -Name "${PSScriptRoot}\..\vendor\lwpm\$soft"
  }else{
    "==> Not Found"
    exit 1
  }
}

Function __install($softs){
  $preVersion=0

  if($softs -contains '--pre'){
    $preVersion=1
  }

  Foreach ($soft in $softs){
    if($soft -eq '--pre'){
      continue
    }
    $soft,$version=$soft.split('@')
    "==> Installing $soft $version ..."
    _import_module $soft

    if($version){
      install $version $preVersion
    }else{
      install -isPre $preVersion
    }
    Remove-Module -Name $soft
  }
}

Function __uninstall($softs){
  Foreach ($soft in $softs){
    "==> Uninstalling $soft ..."
    _import_module $soft
    uninstall
    Remove-Module -Name $soft
  }
}

Function _outdated($softs=$null){
  Write-Host "==> check $softs update ..." -ForegroundColor Green
  composer outdated -d ${PSScriptRoot}/..
}

Function _add($softs){
  Write-Host "==> Add $softs ..." -ForegroundColor Green
  if (!(Test-Path composer.json)){
    composer init -q
    composer config minimum-stability dev
  }

  Foreach($soft in $softs){
    composer require -d ${PSScriptRoot}/../ lwpm/$soft --prefer-source
  }
}

Function __list(){
  ""
  ls "${PSScriptRoot}\lnmp-windows-pm-repo" -Name -Directory
  ""
  cd $source
  exit
}

function __init($soft){
  Write-Host "==> Init $soft ..." -ForegroundColor Green
  $SOFT_ROOT="${PSScriptRoot}\..\vendor\lwpm-dev\$soft"

  if(test-path $SOFT_ROOT){
    Write-Host "==> This package already exists !" -ForegroundColor Red
    cd $source
    exit
  }

  new-item $SOFT_ROOT -ItemType Directory | out-null
  copy-item ${PSScriptRoot}\lnmp-windows-pm-repo\example.psm1 `
            $SOFT_ROOT\${soft}.psm1

  copy-item ${PSScriptRoot}\lnmp-windows-pm-repo\lwpm.json `
            $SOFT_ROOT\lwpm.json

  copy-item ${PSScriptRoot}\lnmp-windows-pm-repo\README.md `
            $SOFT_ROOT\README.md

  if(_command composer){
    composer init -d $SOFT_ROOT `
      --name "lwpm/$soft" `
      --homepage "https://docs.lnmp.khs1994.com/windows/lwpm.html" `
      --license "MIT" `
      -q
  }

  "Please edit $SOFT_ROOT files"

  cd $source
}

function __info($soft){
  _import_module $soft
  getInfo
  Remove-Module -Name $soft
}

function __homepage($soft){
  _import_module $soft
  start-process (homepage)
  Remove-Module -Name $soft
}

function __releases($soft){
  _import_module $soft
  start-process (releases)
  Remove-Module -Name $soft
}

function __bug($soft){
  _import_module $soft
  start-process (bug)
  Remove-Module -Name $soft
}

if($args[0] -eq 'install'){
  $_, $softs = $args
  __install $softs
  cd $source
  exit
}

if($args[0] -eq 'uninstall' -or $args[0] -eq 'remove'){
  $_, $softs = $args
  __uninstall $softs
  cd $source
  exit
}

if($args[0] -eq 'list'){
  $_, $softs = $args
  __list $softs
  cd $source
  exit
}

if($args[0] -eq 'init'){
  if($args[1].length -eq 0){
    "Please input soft name"
    cd $source
    exit
  }
  __init $args[1]
  cd $source
  exit
}

if($args[0] -eq 'info'){
  if($args[1].length -eq 0){
    "Please input soft name"
    cd $source
    exit
  }
  __info $args[1]
  cd $source
  exit
}

if($args[0] -eq 'homepage'){
  if($args[1].length -eq 0){
    "Please input soft name"
    cd $source
    exit
  }
  __homepage $args[1]
  cd $source
  exit
}

if($args[0] -eq 'bug'){
  if($args[1].length -eq 0){
    "Please input soft name"
    cd $source
    exit
  }
  __bug $args[1]
  cd $source
  exit
}

if($args[0] -eq 'releases'){
  if($args[1].length -eq 0){
    "Please input soft name"
    cd $source
    exit
  }
  __releases $args[1]
  cd $source
  exit
}

$command,$opt=$args

switch ($command)
{
  "outdated" {
    _outdated $opt
  }
  # {$_ -in "A","B","C"} {}
  "add" {
    _add $opt
  }
  Default {}
}

cd $source
