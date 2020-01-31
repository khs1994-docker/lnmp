Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath

# https://curl.haxx.se/docs/caextract.html
$PHP_CACERT_DATE="2019-05-15"

$lwpm=ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stableVersion=$lwpm.version
$preVersion=$lwpm.preVersion
$githubRepo=$lwpm.github
$homepage=$lwpm.homepage
$releases=$lwpm.releases
$bug=$lwpm.bug
$name=$lwpm.name
$description=$lwpm.description

Function install_ext($PHP_PREFIX){
  $PHP_INI="${PHP_PREFIX}/php.ini"
  $PHP_BIN="${PHP_PREFIX}/php.exe"

  $extensions='yaml',`
         'xdebug',`
         'redis',`
         'mongodb',`
         'igbinary'

  _downloader `
      http://redmine.lighttpd.net/attachments/download/660/RunHiddenConsole.zip `
      RunHiddenConsole.zip `
      RunHiddenConsole

  _downloader `
      https://github.com/khs1994-php/pickle/releases/download/nightly/pickle-debug.phar `
      pickle `
      pickle

  _unzip RunHiddenConsole.zip RunHiddenConsole

  copy-item -r -force RunHiddenConsole\RunHiddenConsole.exe C:\bin
  copy-item -r -force pickle C:\bin
  _cleanup RunHiddenConsole

  _downloader `
      https://github.com/deemru/php-cgi-spawner/releases/download/1.1.23/php-cgi-spawner.exe `
      php-cgi-spawner.exe `
      php-cgi-spawner

  Get-Process php-cgi-spawner -ErrorAction "SilentlyContinue" | out-null

  if(!($?)){
    cp php-cgi-spawner.exe C:\php
  }

  # https://curl.haxx.se/docs/caextract.html
  # https://github.com/khs1994-docker/lnmp/issues/339
  _downloader `
      https://curl.haxx.se/ca/cacert-${PHP_CACERT_DATE}.pem `
      cacert-${PHP_CACERT_DATE}.pem `
      cacert-${PHP_CACERT_DATE}.pem

  copy-item -r -force cacert-${PHP_CACERT_DATE}.pem C:\bin

  Foreach ($extension in $extensions){
    "==> install $extension ..."

    if (Test-Path $HOME/github/pickle/bin/pickle){
      & ${PHP_BIN} $HOME/github/pickle/bin/pickle install $extension --php ${PHP_BIN}
    }else{
      & ${PHP_BIN} C:\bin\pickle install $extension --php ${PHP_BIN}
    }
  }

  #
  # Windows php curl ssl
  #
  # @link https://github.com/khs1994-docker/lnmp/issues/339
  #

  $a = php -r "echo ini_get('curl.cainfo');"

  if ($a -ne "C:\bin\cacert-${PHP_CACERT_DATE}.pem"){
    "curl.cainfo=C:\bin\cacert-${PHP_CACERT_DATE}.pem" `
    | out-file -Append $PHP_INI -encoding utf8
  }

  php -r "echo ini_get('curl.cainfo');"
}

Function install_after($VERSION,$PHP_PREFIX){
  if (!(Test-Path $PHP_PREFIX\php.ini)){
    Copy-Item $PHP_PREFIX\php.ini-development $PHP_PREFIX\php.ini
  }

  install_ext $PHP_PREFIX
}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }
  if($isPre){
    $VC_VERSION="nts-Win32-vc15"
    $VERSION=$preVersion
    $url="https://windows.php.net/downloads/qa/php-${VERSION}-${VC_VERSION}-x64.zip"
    $unzipDesc="php-pre"
    $PHP_PREFIX="C:\php-pre"
  }else{
    $VC_VERSION="nts-Win32-VC15"
    $url="https://windows.php.net/downloads/releases/php-${VERSION}-${VC_VERSION}-x64.zip"
    $unzipDesc="php"
    $PHP_PREFIX="C:\php"
  }

  $filename="php-${VERSION}-${VC_VERSION}-x64.zip"

  _exportPath "C:\php"

  if($(_command php)){
    $CURRENT_VERSION=(php -v).split(" ")[1]

    if ($CURRENT_VERSION -eq $VERSION){
        "==> $name $VERSION already install"

        install_after $VERSION $PHP_PREFIX

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

  install_after ${VERSION} $PHP_PREFIX

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  & ${PHP_PREFIX}/php -v
}

Function uninstall(){
  _cleanup "C:\php"
}
