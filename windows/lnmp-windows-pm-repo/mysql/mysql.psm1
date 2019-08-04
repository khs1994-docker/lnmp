Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description

Function install_after(){
  if(!(Test-Path C:\mysql\data)){

    Write-Host "mysql is init ..."

    mysqld --initialize

    _sudo "mysqld --install"
  }

  if (!(Test-Path C:/mysql/my.cnf)){
    Copy-Item $PSScriptRoot/config/my.cnf C:/mysql/my.cnf
  }

  $mysql_password=($(select-string `
    "A temporary password is generated for" C:\mysql\data\*.err) -split " ")[12]

  Write-host "

Please exec command start(or init) mysql

$ net start mysql

$ mysql -uroot -p`"$mysql_password`"

mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mytest';

mysql> FLUSH PRIVILEGES;

mysql> GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

# add remote login user

mysql> CREATE USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'password';

mysql> GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
"
}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }

  if($isPre){
    $VERSION=$preVersion
  }else{

  }

  $url="https://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-8.0/mysql-${VERSION}-winx64.zip"

  $filename="mysql-${VERSION}-winx64.zip"
  $unzipDesc="mysql"

  _exportPath "C:\mysql\bin"
  $env:path=[environment]::GetEnvironmentvariable("Path","user") `
            + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  if($(_command mysql)){
    $CURRENT_VERSION=(mysql --version).split(" ")[3]

    if ($CURRENT_VERSION -eq $VERSION){
        echo "==> $name $VERSION already install"
        return
    }
  }

  # 下载原始 zip 文件，若存在则不再进行下载
  _downloader `
    $url `
    $filename `
    $name `
    $VERSION

  # 验证原始 zip 文件 Fix me

  # 解压 zip 文件 Fix me
  _cleanup mysql
  _unzip $filename $unzipDesc

  # 安装 Fix me
  _mkdir C:\mysql
  Copy-item -r -force "mysql\mysql-${VERSION}-winx64\*" "C:\mysql\"
  # Start-Process -FilePath $filename -wait
  _cleanup mysql

  # [environment]::SetEnvironmentvariable("", "", "User")
  _exportPath "C:\mysql\bin"
  $env:path=[environment]::GetEnvironmentvariable("Path","user") `
            + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  install_after

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  mysql --version
}

Function uninstall(){
  _sudo "mysqld --uninstall"
  _cleanup C:\mysql
}

Function getInfo(){
  . $PSScriptRoot\..\..\sdk\github\repos\repos.ps1

  $latestVersion=getLatestTag $githubRepo

  echo "
Package: $name
Version: $stableVersion
PreVersion: $preVersion
LatestVersion: $latestVersion
HomePage: $homepage
Releases: $releases
Bugs: $bug
Description: $description
"
}

Function bug(){
  return $bug
}

Function homepage(){
  return $homepage
}

Function releases(){
  return $releases
}
