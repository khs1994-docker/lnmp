$tips = "You MUST edit $HOME\.wslconfig to custom kernel path, please see $HOME\lnmp\wsl2\conf\.wslconfig"

$WSL_DIST = 'wsl-k8s'
$kernelversion = "4.19.121"

if ($env:WSL_DIST) {
  $WSL_DIST = $env:WSL_DIST
}

if ($env:WSL_KERNEL_VERSION) {
  $kernelversion = $env:WSL_KERNEL_VERSION
}

if ($args.Length -eq 0) {
  "WSL2 kernel download/update tool

$tips

COMMAND:

download  download kernel only
install   install linux-headers to WSL2($WSL_DIST) (`${env:WSL_DIST:-wsl-k8s})

ENV:

WSL_KERNEL_VERSION  default is [ 4.19.121 ] , more value see https://github.com/khs1994/WSL2-Linux-Kernel/releases
WSL_DIST            default is [ wsl-k8s ]

"

  exit
}

$EXEC_CMD_DIR = pwd

$deb = "linux-headers-${kernelversion}-microsoft-standard_$(${kernelversion}.split('-')[0])-1_amd64.deb"

mkdir -f ~/.wsl | out-null

cd ~/.wsl


Function _downloader($name, $url) {
  if (Test-Path $name) {
    write-host "==> $name exists, skip download" -ForegroundColor Yellow

    return
  }
  write-host "==> download $name" -ForegroundColor Green
  curl.exe -fL $url -O
}

# 下载文件

_downloader "kernel-${kernelversion}-microsoft-standard.img" "https://github.com/khs1994/WSL2-Linux-Kernel/releases/download/${kernelversion}-microsoft-standard/kernel-${kernelversion}-microsoft-standard.img"
_downloader $deb "https://github.com/khs1994/WSL2-Linux-Kernel/releases/download/${kernelversion}-microsoft-standard/$deb"

# 复制配置文件

if (!(Test-Path $home/.wslconfig)) {
  cp $PSScriptRoot/../config/.wslconfig $home/.wslconfig
}

if ($args[0] -eq 'download') {
  cd $EXEC_CMD_DIR
  Write-Warning $tips
  exit
}

# linux-headers
Write-Host "==> install linux-headers" -ForegroundColor Green

wsl -d ${WSL_DIST} -u root dpkg -i $deb

cd $EXEC_CMD_DIR

Write-Warning $tips
