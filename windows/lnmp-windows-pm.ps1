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
init        Init a new package (developer) [--custom]
push        Push a package to docker registry (developer)
toJson      Convert lwpm.y(a)ml to lwpm.json (need ``$ Install-Module powershell-yaml` )

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
  if (Test-Path "${PSScriptRoot}\..\vendor\lwpm-dev\$soft"){
    write-host "==> Found in vendor/lwpm-dev" -ForegroundColor Green

    return "${PSScriptRoot}\..\vendor\lwpm-dev\$soft"
  }elseif (Test-Path "${PSScriptRoot}\..\vendor\lwpm\$soft"){
    write-host "==> Found in vendor/lwpm" -ForegroundColor Green

    return "${PSScriptRoot}\..\vendor\lwpm\$soft"
  }elseif (Test-Path "${PSScriptRoot}\lnmp-windows-pm-repo\$soft"){
    return "${PSScriptRoot}\lnmp-windows-pm-repo\$soft"
  }elseif (Test-Path "${PSScriptRoot}\lnmp-windows-pm-repo\k8s\$soft"){
    return "${PSScriptRoot}\lnmp-windows-pm-repo\k8s\$soft"
  }else{
    write-host "==> [ $soft ] Not Found" -ForegroundColor Red

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

  $env:LWPM_PKG_ROOT = $soft_ps_module_dir

  if(!(Test-Path $soft_ps_module_dir/$soft.psm1)){
    $env:LWPM_MANIFEST_PATH="$soft_ps_module_dir/lwpm.json"
    $soft_ps_module_dir = "$PSScriptRoot\lnmp-windows-pm-repo\example.psm1"
  }else{
    Write-Host "==> this package include custom script" -ForegroundColor Yellow
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

    if($env:LWPM_DIST_ONLY -eq "true"){
      $pkg_root = pkg_root $soft
      $platforms = (ConvertFrom-Json (cat $pkg_root\lwpm.json -raw)).platform

      foreach ($platform in $platforms) {
        $env:lwpm_architecture = $platform.architecture
        $env:lwpm_os = $platform.os

        if($version){
          install $version $preVersion
        }else{
          install -isPre $preVersion
        }
      }
      $env:lwpm_architecture=$null
      $env:lwpm_os=$null

      _remove_module $soft
      continue
    }

    $env:lwpm_architecture="amd64"
    $env:lwpm_os="windows"

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
}

Function getDockerRegistryToken($image,$action="push,pull"){
  . $PSScriptRoot\sdk\dockerhub\auth\auth.ps1

  if($env:LWPM_DOCKER_REGISTRY){
    . $PSScriptRoot\sdk\dockerhub\auth\token.ps1

    $tokenServer,$tokenService = getTokenServerAndService $env:LWPM_DOCKER_REGISTRY

    return getToken $image $action $tokenServer $tokenService
  }

  return getToken $image $action
}

Function _add($softs){
  $env:REGISTRY_MIRROR=$env:LWPM_DOCKER_REGISTRY
  . $PSScriptRoot\sdk\dockerhub\rootfs.ps1

  Foreach($soft in $softs){
    Write-Host "==> Add [ $soft ] ..." -ForegroundColor Green
    if (!(Test-Path "${PSScriptRoot}/../lwpm.lock.json")){

    }

    if(!($soft.Contains('/'))){
      $soft = "lwpm/$soft"
    }

    $soft,$ref = $soft.split('@')

    if(!($ref)){$ref = 'latest'}
    $dest = rootfs $soft $ref -os windows

    if(!($dest)){
      write-host "==> $soft $ref not found" -ForegroundColor Red

      continue
    }

    $dist = "$PSScriptRoot\..\vendor\lwpm"
    mkdir -Force $dist | out-null
    tar -zxvf $dest -C $dist
  }
}

Function __list(){
  ""
  ls "${PSScriptRoot}\lnmp-windows-pm-repo" -Name -Directory
  ""
  _exit
}

function __init($soft,$custom_script=$false){
  Write-Host "==> Init $soft ..." -ForegroundColor Green
  $SOFT_ROOT="${PSScriptRoot}\..\vendor\lwpm-dev\$soft"

  if(test-path $SOFT_ROOT){
    Write-Host "==> This package already exists" -ForegroundColor Red

    _exit
  }

  new-item $SOFT_ROOT -ItemType Directory | out-null

  if($custom_script){
    Write-Host "==> init package with custom script" -ForegroundColor Yellow

    copy-item ${PSScriptRoot}\lnmp-windows-pm-repo\example.psm1 `
            $SOFT_ROOT\${soft}.psm1
  }

  copy-item ${PSScriptRoot}\lnmp-windows-pm-repo\lwpm.json `
            $SOFT_ROOT\lwpm.json

  copy-item ${PSScriptRoot}\lnmp-windows-pm-repo\README.md `
            $SOFT_ROOT\README.md

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

function _push($opt){
  $ErrorActionPreference="Stop"

  $opt,$version = $opt.split('@')

  if(!($opt.Contains('/'))){
    write-host "==> package name [ $opt ] not include '/', package name use 'lwpm/$opt'" -ForegroundColor Yellow
    $opt = "lwpm/$opt"
  }

  try {
    $pkg_root = pkg_root $opt.split('/')[-1]
  }
  catch {
    return
  }

  if(!$env:LWPM_DOCKER_USERNAME -or !$env:LWPM_DOCKER_PASSWORD){
    write-host ==> please set `$env:LWPM_DOCKER_USERNAME and `$env:LWPM_DOCKER_PASSWORD -ForegroundColor Red

    exit 1
  }

  $registry="registry.hub.docker.com"

  if($env:LWPM_DOCKER_REGISTRY){
    $registry=$env:LWPM_DOCKER_REGISTRY

    write-host "==> push to [ $registry ]" -ForegroundColor Green
  }

  $env:DOCKER_USERNAME=$env:LWPM_DOCKER_USERNAME
  $env:DOCKER_PASSWORD=$env:LWPM_DOCKER_PASSWORD

  Write-Host "==> package found in $pkg_root" -ForegroundColor Blue

  $platforms = (ConvertFrom-Json (cat $pkg_root\lwpm.json -raw)).platform

  if (!($platforms)) {
    $platforms = ConvertFrom-Json -InputObject @"
    [{
      "architecture": "amd64",
      "os"           : "windows"
    }]
"@
  }

  $manifests = 0..($platforms.count-1)
  $i=-1

  foreach ($platform in $platforms) {
    $env:lwpm_architecture = $platform.architecture
    $env:lwpm_os = $platform.os

    $i +=1

    write-host "==> os: $env:lwpm_os ; architecture: $env:lwpm_architecture" -ForegroundColor Green

    $soft = $opt.split('/')[-1]

    $lwpm_temp = "$PSScriptRoot\..\vendor\lwpm-temp\${env:lwpm_os}-${env:lwpm_architecture}\$soft"
    $lwpm_dist_temp = "$PSScriptRoot\..\vendor\lwpm-temp\dist\$soft\${env:lwpm_os}-${env:lwpm_architecture}"

    try { rm -r -force $lwpm_temp }catch { }
    try { rm -r -force $lwpm_dist_temp }catch { }

    mkdir -force $lwpm_temp | out-null
    mkdir -force $lwpm_dist_temp | out-null

    ConvertFrom-Json (cat $pkg_root\lwpm.json -raw) | `
      ConvertTo-Json -Compress > $lwpm_temp\lwpm.json

    try { cp $pkg_root\README.md $lwpm_temp }catch { }
    if(Test-Path $pkg_root\dist\${env:lwpm_os}-${env:lwpm_architecture}){
      cp -r $pkg_root\dist\${env:lwpm_os}-${env:lwpm_architecture}   $lwpm_temp\dist
    }else{
      try { cp -r $pkg_root\dist   $lwpm_temp }catch { }
    }

    if (Test-Path $pkg_root\$soft.psm1) {
      cp $pkg_root\${soft}.psm1 $lwpm_temp
    }

    $tar_file = "$lwpm_dist_temp\lwpm.tar.gz"
    cd $lwpm_temp\..\
    tar -zcvf lwpm.tar.gz $soft
    mv lwpm.tar.gz $tar_file

    $token = getDockerRegistryToken $opt

    $config_file = "$lwpm_temp/lwpm.json"

    . $PSScriptRoot\sdk\dockerhub\blobs\upload.ps1

    try {
      $length, $sha256 = upload $token $opt $tar_file -registry $registry
      $config_length, $config_sha256 = upload $token $opt $config_file "application/vnd.docker.container.image.v1+json" $registry
    }
    catch {
      write-host $_.Exception
      return;
    }

    $data = ConvertTo-Json @{
      "schemaVersion" = 2;
      "mediaType"     = "application/vnd.docker.distribution.manifest.v2+json";
      "config"        = @{
        "mediaType" = "application/vnd.docker.container.image.v1+json";
        "size"      = $config_length;
        "digest"    = "sha256:$config_sha256";
      };
      "layers"        = @(@{
          "mediaType" = "application/vnd.docker.image.rootfs.diff.tar.gzip";
          "size"      = $length;
          "digest"    = "sha256:$sha256";
        })
    } -Compress

    $manifest_json_path = "$lwpm_dist_temp/manifest.json"
    write-output $data > $manifest_json_path

    . $PSScriptRoot\sdk\dockerhub\manifests\upload.ps1

    if (!($version)) {
      $version = "latest"
    }

    # push manifest
    $manifest_length, $manifest_sha256 = upload $token $opt $version $manifest_json_path -registry $registry

    # generate manifest list
    $manifest = @{
        "digest"    = "sha256:$manifest_sha256";
        "mediaType" = "application/vnd.docker.distribution.manifest.v2+json";
        "platform"  = @{
          "architecture" = $env:lwpm_architecture;
          "os"           = $env:lwpm_os;
        };
        "size"      = $manifest_length;
    };

    $manifests[$i] =$manifest
  }

  $data = ConvertTo-Json -InputObject @{
    "mediaType"     = "application/vnd.docker.distribution.manifest.list.v2+json";
    "schemaVersion" = 2;
    "manifests"     = $manifests
  } -Compress -Depth 10

  $manifest_list_json_path = "$lwpm_dist_temp/manifest_list.json"
  write-output $data > $manifest_list_json_path

  # push manifest list
  $manifest_length, $manifest_sha256 = upload $token $opt $version $manifest_list_json_path "application/vnd.docker.distribution.manifest.list.v2+json" $registry
}

function _toJson($soft){
  get-command ConvertFrom-Yaml | out-null

  try{ $pkg_root = pkg_root $soft }catch{ return }

    if(Test-Path $pkg_root/lwpm.yml){
      $yaml_file="lwpm.yml"
    }

    if(Test-Path $pkg_root/lwpm.yaml){
      $yaml_file="lwpm.yaml"
    }

    if(!$yaml_file){
       Write-Host "==> lwpm.yml or lwpm.yaml file not found" -ForegroundColor Red

       return
    }

    (ConvertFrom-Yaml (cat $pkg_root\$yaml_file -raw) | `
    ConvertTo-Yaml -JsonCompatible) -Join "" | Set-Content -NoNewline $pkg_root\lwpm.json

    Write-Host "==> [ $soft ] success, please see $pkg_root\lwpm.json" -ForegroundColor Green
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

  if($args[2] -eq '--custom'){
    __init $args[1] $true

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

  "push" {
    if(!($opt)){
      write-host "==> please input package name" -ForegroundColor Red

      _exit
    }

    foreach ($item in $opt) {
      _push $item
    }
  }

  "toJson" {
    foreach ($item in $opt) {
      _toJson $item
    }
  }

  Default {
    print_help_info
  }
}

cd $EXEC_CMD_DIR
