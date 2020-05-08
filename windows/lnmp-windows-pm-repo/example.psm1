Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath
Import-Module getHttpCode

$ErrorActionPreference = 'stop'

if (Test-Path $PSScriptRoot\lwpm-json-schema.json) {
  if (!($env:LWPM_MANIFEST_PATH)) {
    Write-Host "==> lwpm package without custom script load error" -ForegroundColor Red

    exit 1
  }
  $lwpm = ConvertFrom-Json -InputObject (get-content $env:LWPM_MANIFEST_PATH -Raw)
}
else {
  $lwpm = ConvertFrom-Json -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)
}

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

  iex $str
}

Function _install_after() {
  if (!$lwpm.scripts.postinstall) {

    return
  }

  foreach ($item in $lwpm.scripts.postinstall) {
    _iex $item
  }
}

Function _getUrl($url, $url_mirror, $VERSION) {
  if ($url_mirror -and ($env:LNMP_CN_ENV -ne "false")) {
    Write-Host "==> Try use Download url mirror" -ForegroundColor Green
    $download_url = $url_mirror.replace('${VERSION}', ${VERSION})
    if ((_getHttpCode $download_url)[0] -eq 4) {
      $download_url = $url.replace('${VERSION}', ${VERSION})

      Write-Host "==> Download url mirror not work" -ForegroundColor Yellow
    }
  }
  else {
    $download_url = $url.replace('${VERSION}', ${VERSION})
  }

  return $download_url
}

Function _install($VERSION = 0, $isPre = 0) {
  if ($isPre) {
    if (!($VERSION)) {
      $VERSION = $pre_version
    }

    # stable 与 pre 的 url 不相同
    if ($lwpm.'pre-url') {
       $download_url = _getUrl $pre_url $pre_url_mirror $VERSION
    }

  }
  else {
    if (!($VERSION)) {
      $VERSION = $stable_version
    }
  }

  if (!$download_url) {
    # stable 与 pre 的 url 相同
    $download_url = _getUrl $url $url_mirror $VERSION
  }

  if ($download_url) {
    $url = $download_url
  }

  if($url){ $url = iex "echo $url" }

  # Write-Host "Please download on this website:

  # ${releases}

  # " -ForegroundColor Green
  #  exit

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
      foreach ($item in $lwpm.scripts.version) {
        $CURRENT_VERSION = _iex $item
      }
    }

    # Write-Host $CURRENT_VERSION

    if ($CURRENT_VERSION -eq $VERSION) {
      Write-Host "==> $name $VERSION already install" -ForegroundColor Yellow

      # _install_after

      return
    }
    $ErrorActionPreference = 'stop'
  }

  # 下载原始 zip 文件，若存在则不再进行下载

  if ($url -and ($env:LWPM_DIST_ONLY -ne 'true')) {
    write-host "==> Download from $url" -ForegroundColor Green

    _downloader `
      $url `
      $filename `
      $name `
      $VERSION
  }

  if($lwpm.scripts.download -and ($env:LWPM_DIST_ONLY -eq 'true')){
    write-host "==> Dist files, Download from $url" -ForegroundColor Green

    foreach ($item in $lwpm.scripts.download) {
      _iex $item
    }
  }

  # 验证原始 zip 文件

  # 解压 zip 文件
  # _cleanup "$unzipDesc"
  # _unzip $filename $unzipDesc

  if ($lwpm.scripts.preinstall) {
    foreach ($item in $lwpm.scripts.preinstall) {
      _iex $item
    }
  }

  # install
  # Copy-item -r -force "$unzipDesc/" ""
  if ($lwpm.scripts.install) {
    foreach ($item in $lwpm.scripts.install) {
      _iex $item
    }
  }
  # Start-Process -FilePath $filename -wait
  # _cleanup "$unzipDesc"

  # [environment]::SetEnvironmentvariable("", "", "User")
  if ($lwpm.path) { _exportPath $lwpm.path }

  _install_after

  Write-Host "==> Checking ${name} ${VERSION} install ..." -ForegroundColor Green
  # test
  if ($lwpm.scripts.pretest) {
    foreach ($item in $lwpm.scripts.pretest) {
      _iex $item
    }
  }
  if ($lwpm.scripts.test) {
    foreach ($item in $lwpm.scripts.test) {
      _iex $item
    }
  }
  if ($lwpm.scripts.posttest) {
    foreach ($item in $lwpm.scripts.posttest) {
      _iex $item
    }
  }
}

Function _uninstall($prune = 0) {
  if (!($lwpm.scripts.uninstall)) {
    Write-Host "==> Not Support" -ForegroundColor Red

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

  Write-Host "==> uninstall success" -ForegroundColor Green
}

# 自定义获取最新版本号的方法

function _getLatestVersion() {
  $stable_version = $null
  $pre_version = $null

  # TODO

  return $stable_version, $pre_version
}

function _dist($VERSION=$null){
  if(!($lwpm.scripts.dist)){

    return;
  }

  foreach ($item in $lwpm.scripts.dist) {
    _iex $item
  }
}
