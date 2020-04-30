Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath
Import-Module getHttpCode

$ErrorActionPreference = 'stop'

$lwpm = ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)

$stable_version = $lwpm.version
$pre_version = $lwpm.'pre-version'
$github_repo = $lwpm.github
# $homepage=$lwpm.homepage
$releases = $lwpm.releases
# $bug=$lwpm.bug
$name = $lwpm.name
# $description=$lwpm.description
$url = $lwpm.url
$url_mirror = $lwpm.'url-mirror'
$pre_url = $lwpm.'pre-url'
$pre_url_mirror = $lwpm.'pre-url-mirror'
$insert_path = $lwpm.path

Function _iex($str) {
  if (!($str)) {
    return;
  }
  echo $str
  iex $str
}

Function install_after() {
  foreach ($item in $lwpm.scripts.postinstall) {
    _iex $item
  }
}

Function install($VERSION = 0, $isPre = 0) {
  if (!($VERSION)) {
    $VERSION = $stable_version
  }

  # stable 与 pre url 不同
  # 先定义 stable url
  # $download_url=$url_mirror.replace('${VERSION}',${VERSION})
  # if((_getHttpCode $download_url)[0] -eq 4){
  # $download_url=$url.replace('${VERSION}',${VERSION})
  # }

  if ($isPre) {
    $VERSION = $pre_version

    # 后定义 pre url
    # $download_url=$pre_url_mirror.replace('${VERSION}',${VERSION})
    # if((_getHttpCode $download_url)[0] -eq 4){
    # $download_url=$pre_url.replace('${VERSION}',${VERSION})
    # }
  }
  else {

  }

  # stable 与 pre url 相同，默认
  # $download_url=$url_mirror.replace('${VERSION}',${VERSION})
  # if((_getHttpCode $download_url)[0] -eq 4){
  $download_url = $url.replace('${VERSION}', ${VERSION})
  # }

  if ($download_url) {
    $url = $download_url
  }

  # Write-Host "Please download on this website:

  # ${releases}

  # " -ForegroundColor Green
  #  exit

  # fix me
  $filename = $url.split('/')[-1]
  if ($lwpm.'download-filename') {
    $filename = ($lwpm.'download-filename').replace('${VERSION}', ${VERSION})
  }

  $unzipDesc = $name

  if ($lwpm.path) { _exportPath $lwpm.path }

  if ($lwpm.command -and $(_command $lwpm.command)) {
    $ErrorActionPreference = 'Continue'
    $CURRENT_VERSION = ""

    if ($lwpm.scripts.version) {
      $CURRENT_VERSION = iex $lwpm.scripts.version
    }

    if ($CURRENT_VERSION -eq $VERSION) {
      Write-Host "==> $name $VERSION already install" -ForegroundColor Yellow

      install_after

      return
    }
    $ErrorActionPreference = 'stop'
  }

  # 下载原始 zip 文件，若存在则不再进行下载

  _downloader `
    $url `
    $filename `
    $name `
    $VERSION

  # 验证原始 zip 文件 Fix me

  # 解压 zip 文件 Fix me
  # _cleanup "$unzipDesc"
  # _unzip $filename $unzipDesc

  foreach ($item in $lwpm.scripts.preinstall.replace('${VERSION}', ${VERSION})) {
    _iex $item
  }

  # 安装 Fix me
  # Copy-item -r -force "$unzipDesc/" ""
  foreach ($item in $lwpm.scripts.install.replace('${VERSION}', ${VERSION})) {
    _iex $item
  }
  # Start-Process -FilePath $filename -wait
  # _cleanup "$unzipDesc"

  # [environment]::SetEnvironmentvariable("", "", "User")
  if ($lwpm.path) { _exportPath $lwpm.path }

  install_after

  # Write-Host "==> Checking ${name} ${VERSION} install ..." -ForegroundColor Green
  # 验证 Fix me
  foreach ($item in $lwpm.scripts.pretest.replace('${VERSION}', ${VERSION})) {
    _iex $item
  }
  foreach ($item in $lwpm.scripts.test.replace('${VERSION}', ${VERSION})) {
    _iex $item
  }
  foreach ($item in $lwpm.scripts.posttest.replace('${VERSION}', ${VERSION})) {
    _iex $item
  }
}

Function uninstall($prune = 0) {
  if (!($lwpm.scripts.uninstall)) {
    Write-Host "Not Support" -ForegroundColor Red

    return
  }

  # _cleanup ""
  foreach ($item in $lwpm.scripts.preuninstall) {
    _iex $item
  }
  foreach ($item in $lwpm.scripts.uninstall) {
    _iex $item
  }
  foreach ($item in $lwpm.scripts.postuninstall) {
    _iex $item
  }
  # user data
  if ($prune) {
    # _cleanup ""
    foreach ($item in $lwpm.scripts.pruneuninstall) {
      _iex $item
    }
  }
}

# 自定义获取最新版本号的方法

function getLatestVersion() {
  $stable_version = $null
  $pre_version = $null

  # TODO

  return $stable_version, $pre_version
}
