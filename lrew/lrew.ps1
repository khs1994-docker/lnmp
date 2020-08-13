Import-Module $PSScriptRoot/../windows/powershell_system/print

Function _add($pkg) {
  if ($env:LREW_DOCKER_REGISTRY) {
    $env:REGISTRY_MIRROR = $env:LREW_DOCKER_REGISTRY
  }
  if ($IsDocker) {
    $lrew_dist = "/docker-entrypoint.d/$pkg"
  }
  else {
    $lrew_dist = "$PSScriptRoot/../vendor/lrew/$pkg"
  }

  if (Test-Path $lrew_dist) {
    Write-Warning "[ $pkg ] already exists"

    return
  }
  else {
    mkdir $lrew_dist | out-null
  }

  if (!$env:LREW_DOCKER_NAMESPACE) {
    $env:LREW_DOCKER_NAMESPACE = "lrewpkg"
  }

  . $PSScriptRoot/../windows/sdk/dockerhub/rootfs.ps1
  $dist = rootfs $env:LREW_DOCKER_NAMESPACE/$pkg latest

  if (!$dist -or ($dist -eq $false)) {
    printError "[error] add [ $pkg ] failed"
    Remove-Item -r -Force $lrew_dist

    return
  }
  $ErrorActionPreference = "Continue"
  tar -zxvf $dist -C $lrew_dist
  printInfo "add [ $pkg ] success"
}

Function _init($package = $null) {
  printInfo "LREW init $package ..."

  if (!$package) {
    printError "Please Input package name"
    exit 1
  }

  if ($IsDocker) {
    $pkg_root = "/docker-entrypoint.d/$package"
  }
  else {
    $pkg_root = "$PSScriptRoot/../vendor/lrew-dev/$package"
  }

  if (Test-Path $pkg_root) {
    printError "This package already exists"
    return
  }

  cp -r $PSScriptRoot/example $pkg_root

  $items = "docker-compose.yml", "docker-compose.override.yml", "docker-compose.build.yml"

  Foreach ($item in $items) {
    $file = "$pkg_root/$item"

    @(Get-Content $file) -replace `
      'LREW_EXAMPLE_VENDOR', "LREW_$( $package -Replace('-','_'))_VENDOR".ToUpper() | Set-Content $file

    @(Get-Content $file) -replace `
      'LNMP_EXAMPLE_', "LNMP_$( $package -Replace('-','_'))_".ToUpper() | Set-Content $file

    @(Get-Content $file) -replace `
      'example/', "${package}/" | Set-Content $file

    @(Get-Content $file) -replace `
      '{{example}}', "${package}" | Set-Content $file
  }

  if (Test-Path "$pkg_root/.env.example") {
    cp -r "$pkg_root/.env.example" "$pkg_root/.env"
  }
}

Function _push($pkg) {
  if ((!$env:LREW_DOCKER_USERNAME) -or (!$env:LREW_DOCKER_PASSWORD)) {
    printError "please set `$env:LREW_DOCKER_USERNAME and `$env:LREW_DOCKER_PASSWORD"

    exit 1
  }

  $env:LWPM_DOCKER_USERNAME = $env:LREW_DOCKER_USERNAME
  $env:LWPM_DOCKER_PASSWORD = $env:LREW_DOCKER_PASSWORD
  $env:LWPM_DOCKER_REGISTRY = $env:LREW_DOCKER_REGISTRY

  if ($IsDocker) {
    $env:LREW_PKG_ROOT = "/docker-entrypoint.d/$pkg"
    if (!(Test-Path $env:LREW_PKG_ROOT)) {
      $env:LREW_PKG_ROOT = "/docker-entrypoint.d"
      if (!(Test-Path "$env:LREW_PKG_ROOT/docker-compose.yml")) {
        printError "$env:LREW_PKG_ROOT not include docker-compose.yml"

        return
      }
    }
  }
  else {
    $env:LREW_PKG_ROOT = "$PSScriptRoot/../vendor/lrew-dev/$pkg"
  }

  if ($env:LREW_DOCKER_NAMESPACE) {
    $env:LWPM_DOCKER_NAMESPACE = $env:LREW_DOCKER_NAMESPACE
  }
  else {
    $env:LWPM_DOCKER_NAMESPACE = "lrewpkg"
  }
  & $PSScriptRoot/../windows/lnmp-windows-pm.ps1 push $pkg
  $env:LREW_PKG_ROOT = $null
  $env:LWPM_DOCKER_NAMESPACE = $null
}

Function _outdated($packages = $null) {
  printInfo "check $packages update ..."

  if (!(Test-Path vendor/lrew)) {
    return
  }
}

Function _update($packages = $null) {
  printInfo "update $packages ..."

  if (!(Test-Path vendor/lrew)) {
    return
  }

  Foreach ($package in $packages) {
    $pkg_root = "$PSScriptRoot/../vendor/lrew/$package"

    if (!(Test-Path $pkg_root)) {
      continue
    }

    cd $pkg_root
    if (Test-Path bin/post-install.ps1) {
      . ./bin/post-install.ps1
    }
  }
}

$global:IsDocker = $false

if (Test-Path /.dockerenv) {
  $global:IsDocker = $true
}

$command, $pkgs = $args

switch ($command) {
  add {
    foreach ($pkg in $pkgs) {
      _add $pkg
    }
  }

  init {
    foreach ($pkg in $pkgs) {
      _init $pkg
    }
  }

  push {
    Get-Command git -ErrorAction SilentlyContinue > $null 2>&1
    if (!$?) {
      printError "git command not found, please install git"
      exit 1
    }

    foreach ($pkg in $pkgs) {
      _push $pkg
    }
  }

  Default {
    write-host "
COMMAND:

add

DEVELOPER:

init
push

ENV:

LREW_DOCKER_USERNAME
LREW_DOCKER_PASSWORD
LREW_DOCKER_REGISTRY

LREW_DOCKER_NAMESPACE=lrewpkg

LREW_PKG_ROOT
    "
  }
}
