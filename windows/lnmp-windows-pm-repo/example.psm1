Import-Module downloader
Import-Module unzip
Import-Module command
Import-Module cleanup
Import-Module exportPath
Import-Module getHttpCode

$ErrorActionPreference = 'stop'

if (Test-Path $PSScriptRoot\lwpm.schema.json) {
  if (!($env:LWPM_MANIFEST_PATH)) {
    Write-Host "==> lwpm package without custom script load error" -ForegroundColor Red

    exit 1
  }
  $lwpm = ConvertFrom-Json -Depth 5 -InputObject (get-content $env:LWPM_MANIFEST_PATH -Raw)
}
else {
  $lwpm = ConvertFrom-Json -Depth 5 -InputObject (get-content $PSScriptRoot/lwpm.json -Raw)
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

Function _install_after() {
  if (!$lwpm.scripts.postinstall) {

    return
  }

  foreach ($item in $lwpm.scripts.postinstall) {
    try { iex $item }catch { printError $_.Exception }
  }
}

Function _getUrl($url, $url_mirror, $VERSION) {
  if (!$url) { return }
  if ($url) { $url = iex "echo $url" }

  if ($url_mirror -and ($env:LNMP_CN_ENV -ne "false")) {
    $url_mirror = iex "echo $url_mirror"
    Write-Host "==> Try download from mirror" -ForegroundColor Green
    $download_url = $url_mirror.replace('${VERSION}', ${VERSION})

    if ((_getHttpCode $download_url)[0] -eq '4') {
      $download_url = $url.replace('${VERSION}', ${VERSION})

      Write-Host "==> Download url mirror not work" -ForegroundColor Yellow
    }
  }
  else {
    $download_url = $url.replace('${VERSION}', ${VERSION})
  }

  return $download_url
}

Function Get-HashFromUrl($url) {
  try {
    Invoke-WebRequest $url -OutFile Temp:/hash-$name

    return (Get-Content Temp:/hash-$name | Select-String $filename).Line.split(' ')[0]
  }
  catch {
    printInfo get hash from url failed
    return
  }
}

Function _install($VERSION = 0, $isPre = 0, [boolean]$force = $false) {
  if ($lwpm.scripts.'platform-reqs' -and ($env:LWPM_DIST_ONLY -ne 'true')) {
    foreach ($item in $lwpm.scripts.'platform-reqs') {
      try { $result = iex $item }catch {}
    }

    if ($result -eq $false) {
      printError "Not Support this platform $env:lwpm_os $env:lwpm_architecture , skip"

      return
    }
  }

  if ($lwpm.scripts.'get-version') {
    try { iex $lwpm.scripts.'get-version' }catch { printError $_.Exception }
  }

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

  if ($url) { $url = iex "echo $url" }

  # Write-Host "Please download on this website:

  # ${releases}

  # " -ForegroundColor Green
  #  exit

  if ($url) { $filename = $url.split('/')[-1] }
  if ($download_filename = $lwpm.'download-filename') {
    $filename = iex "echo $download_filename"
  }

  if (!$unzipDesc) { $unzipDesc = $name }

  if ($lwpm.path) { _exportPath $lwpm.path }

  if ($lwpm.command `
      -and $(_command $lwpm.command) `
      -and !$force `
      -and ($env:LWPM_DIST_ONLY -ne 'true')) {
    $ErrorActionPreference = 'Continue'
    $CURRENT_VERSION = ""

    if ($lwpm.scripts.version) {
      foreach ($item in $lwpm.scripts.version) {
        try { $CURRENT_VERSION = iex $item }catch {}
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

    if ($lwpm.platform) {
      foreach ($item in $lwpm.platform) {
        if ($item.os -eq $env:lwpm_os -and $item.architecture -eq $env:lwpm_architecture) {
          if ($item.hash.sha256) {
            $hashType = 'sha256'
            $hash = $item.hash.sha256

            break
          }

          if ($item.hash.sha512) {
            $hashType = 'sha512'
            $hash = $item.hash.sha512

            break
          }

          break
        }
      }
    }

    if ($lwpm.'hash-url') {
      if ($hash_url = $lwpm.'hash-url'.sha256) {
        $hashType = 'sha256'
        $hash = Get-HashFromUrl $(iex "echo $hash_url")
      }

      if ($hash_url = $lwpm.'hash-url'.sha384) {
        $hashType = 'sha384'
        $hash = Get-HashFromUrl $(iex "echo $hash_url")
      }

      if ($hash_url = $lwpm.'hash-url'.sha512) {
        $hashType = 'sha512'
        $hash = Get-HashFromUrl $(iex "echo $hash_url")
      }
    }

    _downloader `
      $url `
      $filename `
      $name `
      $VERSION `
      -HashType $hashType `
      -Hash $hash

    if ($lwpm.scripts.hash) {
      foreach ($item in $lwpm.scripts.hash) {
        try { iex $item }catch { printError $_.Exception }
      }
    }
  }

  if ($lwpm.scripts.dist -and ($env:LWPM_DIST_ONLY -eq 'true')) {
    write-host "==> Dist files, Download from $url" -ForegroundColor Green

    foreach ($item in $lwpm.scripts.dist) {
      try { iex $item }catch { printError $_.Exception }
    }

    printInfo Dist success

    return
  }

  if ($env:LWPM_DIST_ONLY -eq 'true') {
    printError "dist script not found"

    return
  }

  # 验证原始 zip 文件

  # 解压 zip 文件
  # _cleanup "$unzipDesc"
  # _unzip $filename $unzipDesc

  if ($lwpm.scripts.preinstall) {
    foreach ($item in $lwpm.scripts.preinstall) {
      iex $item
    }
  }

  # install
  # Copy-item -r -force "$unzipDesc/" ""
  if ($lwpm.scripts.install) {
    foreach ($item in $lwpm.scripts.install) {
      try { iex $item }catch { printError $_.Exception }
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
      try { iex $item }catch { printError $_.Exception }
    }
  }
  if ($lwpm.scripts.test) {
    foreach ($item in $lwpm.scripts.test) {
      try { iex $item }catch { printError $_.Exception }
    }
  }
  if ($lwpm.scripts.posttest) {
    foreach ($item in $lwpm.scripts.posttest) {
      try { iex $item }catch { printError $_.Exception }
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
    try { iex $item }catch { printError $_.Exception }
  }
  foreach ($item in $lwpm.scripts.uninstall) {
    try { iex $item }catch { printError $_.Exception }
  }
  foreach ($item in $lwpm.scripts.postuninstall) {
    try { iex $item }catch { printError $_.Exception }
  }
  # user data
  if ($prune) {
    # _cleanup ""
    foreach ($item in $lwpm.scripts.pruneuninstall) {
      try { iex $item }catch { printError $_.Exception }
    }
  }

  Write-Host "==> uninstall success" -ForegroundColor Green
}

# 自定义获取最新版本号的方法

function _getLatestVersion() {
  $stable_version = $null
  $pre_version = $null

  # TODO

  if ($lwpm.scripts.'get-latest-version') {
    iex $lwpm.scripts.'get-latest-version'
    if (Get-Command Get-LatestVersion -ErrorAction SilentlyContinue) {
      return Get-LatestVersion
    }
  }

  return $stable_version, $pre_version
}
