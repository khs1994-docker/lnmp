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

Function install_ext(){
  $PHP_INI="C:/php/php.ini"

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
      https://github.com/khs1994-php/pickle/releases/download/v19.11.11/pickle.phar `
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
    php -r "if(extension_loaded('$extension')===true){exit(0);}exit(1);"

    if($?){
      "==> extension $extension already loaded, skip"

      continue
    }

    if (Test-Path $HOME/github/pickle/bin/pickle){
      php $HOME/github/pickle/bin/pickle install $extension
    }else{
      php C:\bin\pickle install $extension
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
      "==> Not Support this version, SKIP install extension"
      return
    }
  }

  if (!(Test-Path C:\php\php.ini)){
    mv C:\php\php.ini-development C:\php\php.ini
  }

  install_ext $PHP_BIN $PHP_INI
}

Function install($VERSION=0,$isPre=0){
  if(!($VERSION)){
    $VERSION=$stableVersion
  }
  if($isPre){
    $VC_VERSION="nts-Win32-vc15"
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

  if($(_command php)){
    $CURRENT_VERSION=(php -v).split(" ")[1]

    if ($CURRENT_VERSION -eq $VERSION){
        "==> $name $VERSION already install"

        install_after $VERSION

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

  install_after $VERSION

  "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  if($isPre){
    C:\php74\php -v
    return
  }

  php -v
}

Function uninstall(){
  _cleanup "C:\php"
}

Function getInfo(){
  . $PSScriptRoot\..\..\sdk\github\repos\repos.ps1

  $latestVersion=(getLatestTag $githubRepo 0 5).trim("php-")

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

Function bug(){
  return $bug
}

Function homepage(){
  return $homepage
}

Function releases(){
  return $releases
}
