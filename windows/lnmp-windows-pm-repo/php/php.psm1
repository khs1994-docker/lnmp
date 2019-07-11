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

Function install_ext(){
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
      https://windows.php.net/downloads/pecl/releases/yaml/$PHP_YAML_EXTENSION_VERSION/php_yaml-$PHP_YAML_EXTENSION_VERSION-7.3-nts-vc15-x64.zip `
      C:\php-ext\php_yaml-$PHP_YAML_EXTENSION_VERSION-7.3-nts-vc15-x64.zip `
      php_yaml-$PHP_YAML_EXTENSION_VERSION-7.3-nts-vc15-x64 null $false
    # https://pecl.php.net/package/xdebug
    _downloader `
      https://windows.php.net/downloads/pecl/releases/xdebug/$PHP_XDEBUG_EXTENSION_VERSION/php_xdebug-$PHP_XDEBUG_EXTENSION_VERSION-7.3-nts-vc15-x64.zip `
      C:\php-ext\php_xdebug-$PHP_XDEBUG_EXTENSION_VERSION-7.3-nts-vc15-x64.zip `
      php_xdebug-$PHP_XDEBUG_EXTENSION_VERSION-7.3-nts-vc15-x64.zip null $false
    # https://pecl.php.net/package/redis
    _downloader `
      https://windows.php.net/downloads/pecl/releases/redis/$PHP_REDIS_EXTENSION_VERSION/php_redis-$PHP_REDIS_EXTENSION_VERSION-7.3-nts-vc15-x64.zip `
      C:\php-ext\php_redis-$PHP_REDIS_EXTENSION_VERSION-7.3-nts-vc15-x64.zip `
      php_redis-$PHP_REDIS_EXTENSION_VERSION-7.3-nts-vc15-x64.zip null $false
    # https://pecl.php.net/package/mongodb
    _downloader `
      https://windows.php.net/downloads/pecl/releases/mongodb/$PHP_MONGODB_EXTENSION_VERSION/php_mongodb-$PHP_MONGODB_EXTENSION_VERSION-7.3-nts-vc15-x64.zip `
      C:\php-ext\php_mongodb-$PHP_MONGODB_EXTENSION_VERSION-7.3-nts-vc15-x64.zip `
      php_mongodb-$PHP_MONGODB_EXTENSION_VERSION-7.3-nts-vc15-x64.zip null $false
    # https://pecl.php.net/package/igbinary
    _downloader `
      https://windows.php.net/downloads/pecl/releases/igbinary/$PHP_IGBINARY_EXTENSION_VERSION/php_igbinary-$PHP_IGBINARY_EXTENSION_VERSION-7.3-nts-vc15-x64.zip `
      C:\php-ext\php_igbinary-$PHP_IGBINARY_EXTENSION_VERSION-7.3-nts-vc15-x64.zip `
      php_igbinary-$PHP_IGBINARY_EXTENSION_VERSION-7.3-nts-vc15-x64.zip null $false
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

    _pecl php_igbinary-$PHP_IGBINARY_EXTENSION_VERSION-7.3-nts-vc15-x64.zip php_igbinary.dll

    _pecl php_mongodb-$PHP_MONGODB_EXTENSION_VERSION-7.3-nts-vc15-x64.zip php_mongodb.dll

    _pecl php_redis-$PHP_REDIS_EXTENSION_VERSION-7.3-nts-vc15-x64.zip php_redis.dll

    _pecl php_xdebug-$PHP_XDEBUG_EXTENSION_VERSION-7.3-nts-vc15-x64.zip php_xdebug.dll

    _pecl php_yaml-$PHP_YAML_EXTENSION_VERSION-7.3-nts-vc15-x64.zip php_yaml.dll

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

Function install_after(){
  if (!(Test-Path C:\php\php.ini)){
    mv C:\php\php.ini-development C:\php\php.ini
  }

  install_ext
}

Function install($VERSION="7.3.7",$PreVersion=0){
  if($PreVersion){
    $VERSION=""
    $url=""
  }else{
    $url="https://windows.php.net/downloads/releases/php-${VERSION}-nts-Win32-VC15-x64.zip"
  }
  $name="php"
  $filename="php-${VERSION}-nts-Win32-VC15-x64.zip"
  $unzipDesc="php"

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
  _cleanup "php"
  _unzip $filename $unzipDesc

  # 安装 Fix me
  _mkdir C:\php
  Copy-item -r -force "php" "C:\"
  # Start-Process -FilePath $filename -wait
  _cleanup "php"

  # [environment]::SetEnvironmentvariable("", "", "User")
  _exportPath "C:\php"
  $env:path=[environment]::GetEnvironmentvariable("Path","user") `
            + ';' + [environment]::GetEnvironmentvariable("Path","machine")

  install_after

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  php -v
}

Function uninstall(){
  _cleanup "C:\php" "C:\php-ext"
}
