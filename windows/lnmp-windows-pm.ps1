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
  echo "
LNMP Windows Package Manager

COMMANDS:

install     Install soft
uninstall   Uninstall soft
remove      Uninstall soft
list        List available softs
init        Init a new package(soft)
help        Print help info
"

  exit
}

$ErrorAction="SilentlyContinue"

. "$PSScriptRoot/common.ps1"

$global:source=$PWD

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

$env:Path = [environment]::GetEnvironmentvariable("Path")

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

Function __install($softs){
  $preVersion=0

  if($softs -contains '--pre'){
    $preVersion=1
  }

  Foreach ($soft in $softs){
    if($soft -eq '--pre'){
      continue
    }
    $soft,$version=(echo $soft).split('@')
    echo "==> Installing $soft $version ..."
    Import-Module "${PSScriptRoot}\lnmp-windows-pm-repo\$soft"

    if($version){
      install $version $preVersion
    }else{
      install -preVersion $preVersion
    }
    Remove-Module -Name $soft
  }
}

Function __uninstall($softs){
  Foreach ($soft in $softs){
    echo "==> Uninstalling $soft ..."
    Import-Module -Name "${PSScriptRoot}\lnmp-windows-pm-repo\$soft"
    uninstall
    Remove-Module -Name $soft
  }
}

Function __list(){
  echo ""
  ls "${PSScriptRoot}\lnmp-windows-pm-repo" -Name -Directory
  echo ""
  exit
}

function __init($soft){
  if(test-path ${PSScriptRoot}\lnmp-windows-pm-repo\${soft}\){
    echo "This package already exists !"
    exit
  }
  new-item ${PSScriptRoot}\lnmp-windows-pm-repo\${soft} -ItemType Directory | out-null
  copy-item ${PSScriptRoot}\lnmp-windows-pm-repo\example.psm1 `
            ${PSScriptRoot}\lnmp-windows-pm-repo\${soft}\${soft}.psm1

  echo "Please edit ${PSScriptRoot}\lnmp-windows-pm-repo\${soft}\${soft}.psm1"
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
    echo "Please input soft name"
    cd $source
    exit
  }
  __init $args[1]
  cd $source
  exit
}

cd $source
