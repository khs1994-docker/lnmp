Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stable_version=$lwpm.version
$pre_version=$lwpm.'pre-version'
$github_repo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description
$url=$lwpm.url
$url_mirror=$lwpm.'url-mirror'
$pre_url=$lwpm.'pre-url'
$pre_url_mirror=$lwpm.'pre-url-mirror'
$insert_path=$lwpm.path

Function _install_after(){
  if(!(Test-Path C:\mysql\data)){

    Write-Host "mysql is init ..."

    mysqld --initialize

    # 安装服务

    _sudo "mysqld --install"

    # 禁止开机启动

    _sudo set-service mysql -StartupType Manual
  }

  if (!(Test-Path C:/mysql/my.cnf)){
    Copy-Item $PSScriptRoot/../../config/my.cnf C:/mysql/my.cnf
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

Function _install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stable_version
  }

  if($isPre){
    $VERSION=$pre_version
  }else{

  }

  $download_url=$url_mirror.replace('${VERSION}',${VERSION});

  if((_getHttpCode $url)[0] -eq "4"){
    $download_url=$url.replace('${VERSION}',${VERSION});
  }

  if($download_url){
    $url=$download_url
  }

  $filename="mysql-${VERSION}-winx64.zip"
  $unzipDesc="mysql"

  _exportPath "C:\mysql\bin"

  if($(_command mysql)){
    $CURRENT_VERSION=(mysql --version).split(" ")[3]

    if ($CURRENT_VERSION -eq $VERSION){
        "==> $name $VERSION already install"
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

  _install_after

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  mysql --version
}

Function _uninstall(){
  _sudo "mysqld --uninstall"
  _cleanup C:\mysql
}
