#
# $ set-ExecutionPolicy RemoteSigned
#

$global:source=$PWD
$global:NGINX_VERSION="1.13.12"
$global:PHP_VERSION="7.2.4"
$global:MYSQL_VERSION="5.7.21"
$global:HTTPD_VERSION="2.4.33"
$global:IDEA_VERSION="1.8.3678"
$global:NODE_VEERSION="9.9.0"
$global:GIT_VERSION="2.16.2"
$global:PYTHON_VERSION="3.6.5"
$global:GOLANG_VERSION="1.10.1"

Function _wget($src,$des){
  Invoke-WebRequest -uri $src -OutFile $des
  Unblock-File $des
}

Function _unzip($zip, $folder){
  Expand-Archive -Path $zip -DestinationPath $folder
}

Function _export($k,$v){

}

Function _mv($src,$target){
  if (!(Test-Path $target)){
  Rename-Item $src $target
  }
}

Function _echo_line(){
  Write-Host '  '
  Write-Host '  '
  Write-Host '  '
}

Function _installer($zip, $unzip_path, $unzip_folder_name = 'null', $soft_path = 'null'){
  if (Test-Path $soft_path){
    Write-Host "$unzip_folder_name already installed"
    return
  }

  if (!(Test-Path $unzip_folder_name)){
    _unzip $zip $unzip_path
  }

  if (!($soft_path -eq 'null')){
    _mv $unzip_folder_name $soft_path
  }

}

################################################################################

if (!(test-path C:\init)){
  New-Item C:\init -type directory | Out-Null
}

cd C:\init

Function _downloader($url, $path, $soft, $version = 'null version'){
  if (!(test-path $path)){
    write-host "download $soft $version..."
    _wget $url $path
  }else{
     write-host "skip $soft $version"
  _echo_line
}

}

#
# Git
#

_downloader `
  https://github.com/git-for-windows/git/releases/download/v${GIT_VERSION}.windows.1/Git-${GIT_VERSION}-64-bit.exe `
  Git-${GIT_VERSION}-64-bit.exe `
  Git ${GIT_VERSION}

#
# VC++ library
#

_downloader `
  https://aka.ms/vs/15/release/vc_redist.x64.exe `
  vc_redist.x64.exe `
  vc_redist.x64.exe

#
# NGINX
#

_downloader `
  http://nginx.org/download/nginx-${NGINX_VERSION}.zip `
  nginx-${NGINX_VERSION}.zip `
  NGINX ${NGINX_VERSION}

#
# HTTPD
#

_downloader `
    http://www.apachelounge.com/download/VC15/binaries/httpd-${HTTPD_VERSION}-win64-VC15.zip `
    httpd-${HTTPD_VERSION}-win64-VC15.zip `
    HTTPD ${HTTPD_VERSION}

#
# PHP
#

_downloader `
  http://windows.php.net/downloads/releases/php-${PHP_VERSION}-nts-Win32-VC15-x64.zip `
  php-${PHP_VERSION}-nts-Win32-VC15-x64.zip `
  PHP ${PHP_VERSION}

#
# MySQL
#

_downloader `
  https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-${MYSQL_VERSION}-winx64.zip `
  mysql-${MYSQL_VERSION}-winx64.zip `
  MYSQL ${PHP_VERSION}

#
# Docker
#

_downloader `
  "https://download.docker.com/win/edge/Docker%20for%20Windows%20Installer.exe" `
  "docker.exe" `
  Docker

#
# IDEA
#

_downloader `
  https://download.jetbrains.com/toolbox/jetbrains-toolbox-${IDEA_VERSION}.exe `
  jetbrains-toolbox-${IDEA_VERSION}.exe `
  jetbrains-toolbox ${IDEA_VERSION} `

#
# Node
#

_downloader `
  https://nodejs.org/dist/v${NODE_VEERSION}/node-v${NODE_VEERSION}-win-x64.zip `
  node-v${NODE_VEERSION}-win-x64.zip `
  Node.js ${NODE_VEERSION}

#
# Pytohn
#

_downloader `
  https://www.python.org/ftp/python/${PYTHON_VERSION}/python-${PYTHON_VERSION}-amd64.exe `
  python-${PYTHON_VERSION}-amd64.exe `
  Python ${PYTHON_VERSION}

#
# Golang
#

_downloader `
  https://studygolang.com/dl/golang/go${GOLANG_VERSION}.windows-amd64.msi `
  go${GOLANG_VERSION}.windows-amd64.msi `
  Golang ${GOLANG_VERSION}

################################################################################

_installer nginx-${NGINX_VERSION}.zip                 C:\     C:\nginx-${NGINX_VERSION} C:\nginx

_installer mysql-${MYSQL_VERSION}-winx64.zip          C:\     C:\mysql-${MYSQL_VERSION}-winx64 C:\mysql

_installer php-${PHP_VERSION}-nts-Win32-VC15-x64.zip  C:\php  C:\php

_installer httpd-${HTTPD_VERSION}-win64-VC15.zip      C:\     C:\Apache24

_installer node-v${NODE_VEERSION}-win-x64.zip         C:\     C:\node-v${NODE_VEERSION}-win-x64 C:\node


################################################################################

[environment]::SetEnvironmentvariable("LNMP_PATH", "$HOME\lnmp", "User");

[environment]::SetEnvironmentvariable("Path", "", "User");

$env:Path = [environment]::GetEnvironmentvariable("Path", "Machine")

[environment]::SetEnvironmentvariable("Path", `
  "$env:Path;$env:LNMP_PATH\windows;$env:LNMP_PATH\wsl;`
C:\php;C:\mysql\bin;C:\nginx;C:\Apache24\bin;C:\node;`
$home\AppData\Local\Programs\Python\Python36"`
  , "User")

[environment]::SetEnvironmentvariable("APP_ENV", "windows", "User");

################################################################################

$env:Path = [environment]::GetEnvironmentvariable("Path", "User")

_echo_line

git --version

_echo_line

docker --version

_echo_line

nginx -V

_echo_line

httpd -v

_echo_line

mysql -v

_echo_line

node -v

_echo_line

npm -v

_echo_line

python --version

_echo_line

go version

_echo_line

$env:Path = [environment]::GetEnvironmentvariable("Path", "User")

echo $env:Path

cd $source

################################################################################

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
