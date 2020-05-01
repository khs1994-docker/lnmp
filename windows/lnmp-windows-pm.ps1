#
# $ set-ExecutionPolicy Bypass
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

SERVICES [Require RunAsAdministrator]:

install-service Install service [ServiceName] [CommandLine] [LogFile]
remove-service  Remove service [ServiceName]
start-service   Start service
stop-service    Stop service

"
}

$ErrorActionPreference="SilentlyContinue"

. "$PSScriptRoot/common.ps1"

$EXEC_CMD_DIR=$PWD

# 配置环境变量
[environment]::SetEnvironmentvariable("DOCKER_CLI_EXPERIMENTAL", "enabled", "User")
[environment]::SetEnvironmentvariable("DOCKER_BUILDKIT", "1", "User")
[environment]::SetEnvironmentvariable("APP_ENV", "$APP_ENV", "User")

if(!$Env:PSModulePathSystem){
  $Env:PSModulePathSystem=$Env:PSModulePath
}

$Env:PSModulePath="$Env:PSModulePathSystem" + ";" `
                  + $PSScriptRoot + "\powershell_system" + ";"

_exportPath "C:\bin"

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

function _exit(){
  cd $EXEC_CMD_DIR

  exit
}

if($args.length -eq 0 -or $args[0] -eq '--help' -or $args[0] -eq '-h' -or $args[0] -eq 'help'){
  $_, $softs = $args
  print_help_info

  _exit
}

################################################################################

Function pkg_root($soft){
  if(Test-Path "${PSScriptRoot}\lnmp-windows-pm-repo\$soft"){
    return "${PSScriptRoot}\lnmp-windows-pm-repo\$soft"
  }elseif (Test-Path "${PSScriptRoot}\..\vendor\lwpm-dev\$soft"){
    write-host "==> Found in vendor/lwpm-dev"

    return "${PSScriptRoot}\..\vendor\lwpm-dev\$soft"
  }elseif (Test-Path "${PSScriptRoot}\..\vendor\lwpm\$soft"){
    write-host "==> Found in vendor/lwpm"

    return "${PSScriptRoot}\..\vendor\lwpm\$soft"
  }else{
    write-host "==> Not Found" -ForegroundColor Red

    throw "404"
  }
}

Function _remove_module($soft){
  try{
  $soft_ps_module_dir = pkg_root $soft
  }catch{
    return
  }

  if(!(Test-Path $soft_ps_module_dir/$soft.psm1)){
    Remove-Module -Name example -ErrorAction SilentlyContinue
    return
  }

  Remove-Module -Name $soft -ErrorAction SilentlyContinue
  Remove-Module -Name example -ErrorAction SilentlyContinue
}

Function _import_module($soft){
  $soft_ps_module_dir = pkg_root $soft

  if(!(Test-Path $soft_ps_module_dir/$soft.psm1)){
    Write-Host "==> this package not include custom script" -ForegroundColor Yellow
    $env:LWPM_MANIFEST_PATH="$soft_ps_module_dir/lwpm.json"
    $soft_ps_module_dir = "$PSScriptRoot\lnmp-windows-pm-repo\example.psm1"
  }

  Remove-Module -Name $soft -ErrorAction SilentlyContinue
  Remove-Module example -ErrorAction SilentlyContinue
  Import-Module -Name $soft_ps_module_dir
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
    Write-Host "==> Installing $soft $version ..." -ForegroundColor Blue

    try{
      _import_module $soft
    }catch{
      continue;
    }

    if($version){
      install $version $preVersion
    }else{
      install -isPre $preVersion
    }
    _remove_module $soft
  }
}

Function __uninstall($softs){
  Foreach ($soft in $softs){
    Write-Host "==> Uninstalling $soft ..." -ForegroundColor Red
    
    try{
      _import_module $soft
    }catch{
        continue;
    }

    uninstall
    _remove_module -Name $soft
  }
}

Function _outdated($softs=$null){
  Write-Host "==> check $softs update ..." -ForegroundColor Green
  composer outdated -d ${PSScriptRoot}/..
}

Function _add($softs){
  Write-Host "==> Add $softs ..." -ForegroundColor Green
  if (!(Test-Path "${PSScriptRoot}/../composer.json")){
    composer init -d ${PSScriptRoot}/../ -q -n --stability dev
  }

  Foreach($soft in $softs){
    composer require -d ${PSScriptRoot}/../ lwpm/$soft --prefer-source
  }
}

Function __list(){
  ""
  ls "${PSScriptRoot}\lnmp-windows-pm-repo" -Name -Directory
  ""
  _exit
}

function __init($soft){
  Write-Host "==> Init $soft ..." -ForegroundColor Green
  $SOFT_ROOT="${PSScriptRoot}\..\vendor\lwpm-dev\$soft"

  if(test-path $SOFT_ROOT){
    Write-Host "==> This package already exists" -ForegroundColor Red

    _exit
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

  Write-Host "==> Please edit $SOFT_ROOT files" -ForegroundColor Green

  cd $EXEC_CMD_DIR
}

function manifest($soft){
  $pkg_manifest = $(pkg_root $soft) + "\lwpm.json"

  return ConvertFrom-Json -InputObject (get-content $pkg_manifest -Raw)
}

function getVersionByProvider($soft){
  try{
    _import_module $soft
  }catch{
    return;
  }

  $ErrorActionPreference="SilentlyContinue"
  if(!$(get-command getLatestVersion)){
    _remove_module $soft

    return $null,$null
  }

  $latestVersion,$latestPreVersion = getLatestVersion

  _remove_module $soft

  return $latestVersion,$latestPreVersion
}

function __info($soft){
  $lwpm=manifest $soft

  $stableVersion=$lwpm.version
  $preVersion=$lwpm.'pre-version'
  $githubRepo=$lwpm.github
  $homepage=$lwpm.homepage
  $releases=$lwpm.releases
  $bug=$lwpm.bug
  $name=$lwpm.name
  $description=$lwpm.description

  $latestVersion,$latestPreVersion=getVersionByProvider $soft

  if($githubRepo -and !$latestVersion){
    . $PSScriptRoot\sdk\github\repos\releases.ps1

    $latestVersion,$latestPreVersion=getLatestRelease $githubRepo
  }

  if(!$latestPreVersion){
    $latestPreVersion=$latestVersion
  }

  if(!$stableVersion){
    $stableVersion = $latestVersion
  }

  if(!$preVersion){
    $preVersion = $latestPreVersion
  }

ConvertFrom-Json -InputObject @"
{
"Package": "$name",
"Version": "$stableVersion",
"PreVersion": "$preVersion",
"LatestVersion": "$latestVersion",
"LatestPreVersion": "$latestPreVersion",
"HomePage": "$homepage",
"Releases": "$releases",
"Bugs": "$bug",
"Description": "$description"
}
"@
}

function __homepage($soft){
  $lwpm=manifest $soft
  start-process $lwpm.homepage
}

function __releases($soft){
  $lwpm=manifest $soft
  start-process $lwpm.releases
}

function __bug($soft){
  $lwpm=manifest $soft
  start-process $lwpm.bug
}

if($args[0] -eq 'install'){
  $_, $softs = $args
  __install $softs

  _exit
}

if($args[0] -eq 'uninstall' -or $args[0] -eq 'remove'){
  $_, $softs = $args
  __uninstall $softs

  _exit
}

if($args[0] -eq 'list'){
  $_, $softs = $args
  __list $softs

  _exit
}

if($args[0] -eq 'init'){
  if($args[1].length -eq 0){
    "Please input soft name"
    _exit
  }
  __init $args[1]
  _exit
}

if($args[0] -eq 'info'){
  if($args[1].length -eq 0){
    "Please input soft name"
    _exit
  }
  __info $args[1]
  _exit
}

if($args[0] -eq 'homepage'){
  if($args[1].length -eq 0){
    "Please input soft name"
    _exit
  }
  __homepage $args[1]
  _exit
}

if($args[0] -eq 'bug'){
  if($args[1].length -eq 0){
    "Please input soft name"
    _exit
  }
  __bug $args[1]
  _exit
}

if($args[0] -eq 'releases'){
  if($args[1].length -eq 0){
    "Please input soft name"
    _exit
  }
  __releases $args[1]
  _exit
}

$command,$opt=$args

Import-Module $PSScriptRoot/sdk/service/service.psm1 -Force

switch ($command)
{
  "outdated" {
    _outdated $opt
  }
  # {$_ -in "A","B","C"} {}
  "add" {
    _add $opt
  }

  "install-service" {
    mkdir -Force C:/bin | out-null
    $Global:BaseDir="C:\bin"

    CreateService -ServiceName $opt[0] -CommandLine $opt[1] `
    -LogFile $opt[2] -EnvVaribles $opt[3]

    # @{NODE_NAME = "$nodeName";}
  }

  "remove-service" {
    foreach($item in $opt){
      Write-Host "==> Remove service $item" -ForegroundColor Red
      RemoveService -ServiceName $item
    }
  }

  "start-service" {
    foreach($item in $opt){
      Write-Host "==> Start service $item" -ForegroundColor Green
      start-process "net" -ArgumentList "start",$item -Verb RunAs
    }
  }

  "stop-service" {
    foreach($item in $opt){
      Write-Host "==> Stop service $item" -ForegroundColor Red
      start-process "net" -ArgumentList "stop",$item -Verb RunAs
    }
  }

  Default {
    print_help_info
  }
}

cd $EXEC_CMD_DIR
