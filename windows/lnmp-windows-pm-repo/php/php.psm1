Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

$global:PHP_REDIS_EXTENSION_VERSION="4.3.0"
$global:PHP_MONGODB_EXTENSION_VERSION="1.5.5"
$global:PHP_IGBINARY_EXTENSION_VERSION="3.0.1"
$global:PHP_XDEBUG_EXTENSION_VERSION="2.7.2"
$global:PHP_YAML_EXTENSION_VERSION="2.0.4"
# https://curl.haxx.se/docs/caextract.html
$global:PHP_CACERT_DATE="2019-05-15"

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description

Function install_ext($PHP_VERSION_XY="7.3",$VC_VERSION="nts-vc15"){
  $extensions='yaml',`
         'xdebug',`
         'Zend Opcache',`
         'redis',`
         'mongodb',`
         'igbinary',`
         'curl',`
         'pdo_mysql'

  _mkdir C:\php-ext

  _downloader `
      http://redmine.lighttpd.net/attachments/download/660/RunHiddenConsole.zip `
      RunHiddenConsole.zip `
      RunHiddenConsole

  _unzip RunHiddenConsole.zip RunHiddenConsole

  copy-item -r -force RunHiddenConsole\RunHiddenConsole.exe C:\bin
  _cleanup RunHiddenConsole

  _downloader `
      https://github.com/deemru/php-cgi-spawner/releases/download/1.1.23/php-cgi-spawner.exe `
      php-cgi-spawner.exe `
      php-cgi-spawner

  Get-Process php-cgi-spawner -ErrorAction "SilentlyContinue" | out-null

  if(!($?)){
    cp php-cgi-spawner.exe C:\php
  }

  cp -Force C:\php\php.ini C:\php-ext\php.ini
    #
    # pecl
    #

    # https://pecl.php.net/package/yaml
    _downloader `
      https://windows.php.net/downloads/pecl/releases/yaml/$PHP_YAML_EXTENSION_VERSION/php_yaml-$PHP_YAML_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip `
      C:\php-ext\php_yaml-$PHP_YAML_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip `
      php_yaml-$PHP_YAML_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64 null $false
    # https://pecl.php.net/package/xdebug
    _downloader `
      https://windows.php.net/downloads/pecl/releases/xdebug/$PHP_XDEBUG_EXTENSION_VERSION/php_xdebug-$PHP_XDEBUG_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip `
      C:\php-ext\php_xdebug-$PHP_XDEBUG_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip `
      php_xdebug-$PHP_XDEBUG_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip null $false
    # https://pecl.php.net/package/redis
    _downloader `
      https://windows.php.net/downloads/pecl/releases/redis/$PHP_REDIS_EXTENSION_VERSION/php_redis-$PHP_REDIS_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip `
      C:\php-ext\php_redis-$PHP_REDIS_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip `
      php_redis-$PHP_REDIS_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip null $false
    # https://pecl.php.net/package/mongodb
    _downloader `
      https://windows.php.net/downloads/pecl/releases/mongodb/$PHP_MONGODB_EXTENSION_VERSION/php_mongodb-$PHP_MONGODB_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip `
      C:\php-ext\php_mongodb-$PHP_MONGODB_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip `
      php_mongodb-$PHP_MONGODB_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip null $false
    # https://pecl.php.net/package/igbinary
    _downloader `
      https://windows.php.net/downloads/pecl/releases/igbinary/$PHP_IGBINARY_EXTENSION_VERSION/php_igbinary-$PHP_IGBINARY_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip `
      C:\php-ext\php_igbinary-$PHP_IGBINARY_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip `
      php_igbinary-$PHP_IGBINARY_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip null $false
    # https://curl.haxx.se/docs/caextract.html
    # https://github.com/khs1994-docker/lnmp/issues/339
    _downloader `
      https://curl.haxx.se/ca/cacert-${PHP_CACERT_DATE}.pem `
      C:\php-ext\cacert-${PHP_CACERT_DATE}.pem `
      C:\php-ext\cacert-${PHP_CACERT_DATE}.pem null $false

    Function _pecl($zip,$file){
      if (!(Test-Path C:\php-ext\$file)){
        _unzip C:\php-ext\$zip C:\php-ext\temp
        mv C:\php-ext\temp\$file C:\php-ext\$file
      }
    }

    _pecl php_igbinary-$PHP_IGBINARY_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip php_igbinary.dll

    _pecl php_mongodb-$PHP_MONGODB_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip php_mongodb.dll

    _pecl php_redis-$PHP_REDIS_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip php_redis.dll

    _pecl php_xdebug-$PHP_XDEBUG_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip php_xdebug.dll

    _pecl php_yaml-$PHP_YAML_EXTENSION_VERSION-$PHP_VERSION_XY-$VC_VERSION-x64.zip php_yaml.dll

    Foreach ($extension in $extensions){
      $a = php -r "echo extension_loaded('$extension');"

      if (!($a -eq 1)){

      if ($extension -eq 'Zend Opcache'){
        echo ' ' | out-file -Append C:/php/php.ini -encoding utf8
        echo "zend_extension=opcache" | out-file -Append C:/php/php.ini -encoding utf8
        continue
      }

      if (!(Test-Path C:\php-ext\php_$extension.dll)){
        if ((Test-Path C:\php\ext\php_$extension.dll)){
          echo ' ' | out-file -Append C:/php/php.ini -encoding utf8
          echo "extension=$extension" | out-file -Append C:/php/php.ini -encoding utf8
        }else{
          continue
        }
        continue
      }

      if ($extension -eq 'xdebug'){
        echo ' ' | out-file -Append C:/php/php.ini -encoding utf8
        echo "; zend_extension=C:\php-ext\php_$extension" | out-file -Append C:/php/php.ini -encoding utf8
        continue
      }
      echo ' ' | out-file -Append C:/php/php.ini -encoding utf8
      echo "extension=C:\php-ext\php_$extension" | out-file -Append C:/php/php.ini -encoding utf8
    }
  }

  #
  # Windows php curl ssl
  #
  # @link https://github.com/khs1994-docker/lnmp/issues/339
  #

  $a = php -r "echo ini_get('curl.cainfo');"

  if ($a -ne "C:\php-ext\cacert-${PHP_CACERT_DATE}.pem"){
    echo "curl.cainfo=C:\php-ext\cacert-${PHP_CACERT_DATE}.pem" | out-file -Append C:/php/php.ini -encoding utf8
  }

  php -r "echo ini_get('curl.cainfo');"
}

Function install_after($VERSION){
  $PHP_VERSION_XY=$VERSION.split(".")[0]+'.'+$VERSION.split(".")[1]

  switch ($PHP_VERSION_XY)
  {
    {$_ -in "7.1","7.0"} {
      $VC_VERSION="nts-vc14"
    }
    {$_ -in "7.2","7.3"} {
      $VC_VERSION="nts-vc15"
    }
    # {$_ -in "A","B","C"} {}
    # "7.4" {
    #   $VC_VERSION=
    # }
    Default {
      echo "==> Not Support this version, SKIP install extension"
      return
    }
  }

  if (!(Test-Path C:\php\php.ini)){
    mv C:\php\php.ini-development C:\php\php.ini
  }

  install_ext $PHP_VERSION_XY $VC_VERSION
}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }
  if($isPre){
    $VC_VERSION="nts-Win32-vs16"
    $VERSION=$preVersion
    $url="https://windows.php.net/downloads/qa/php-${VERSION}-${VC_VERSION}-x64.zip"
    $unzipDesc="php74"
  }else{
    $VC_VERSION="nts-Win32-VC15"
    $url="https://windows.php.net/downloads/releases/php-${VERSION}-${VC_VERSION}-x64.zip"
    $unzipDesc="php"
  }

  $filename="php-${VERSION}-${VC_VERSION}-x64.zip"

  _exportPath "C:\php"
  $env:path=[environment]::GetEnvironmentvariable("Path","user") `
            + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  if($(_command php)){
    $CURRENT_VERSION=(php -v).split(" ")[1]

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
  _cleanup "$unzipDesc"
  _unzip $filename $unzipDesc

  # 安装 Fix me
  Copy-item -r -force "$unzipDesc" "C:\"
  # Start-Process -FilePath $filename -wait
  _cleanup "$unzipDesc"

  # [environment]::SetEnvironmentvariable("", "", "User")
  _exportPath "C:\php"
  $env:path=[environment]::GetEnvironmentvariable("Path","user") `
            + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  install_after $VERSION

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  if($isPre){
    C:\php74\php -v
    return
  }

  php -v
}

Function uninstall(){
  _cleanup "C:\php" "C:\php-ext"
}

Function getInfo(){
  . $PSScriptRoot\..\..\sdk\github\repos\repos.ps1

  $latestVersion=(getLatestTag $githubRepo 0 5).trim("php-")

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
