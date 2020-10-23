$tips = "You MUST edit $HOME\.wslconfig to custom kernel path, please see $HOME\lnmp\wsl2\config\.wslconfig"

$WSL_DIST = 'wsl-k8s'
$defaultKernelVersion = $(Write-Output $(Get-Content $PSScriptRoot/../kernel.version))
$kernelversion = $defaultKernelVersion

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
config    Open $HOME\.wslconfig

ENV:

`$env:WSL_KERNEL_VERSION  default is [ $defaultKernelVersion ]
                         more version see https://github.com/khs1994/WSL2-Linux-Kernel/releases
`$env:WSL_DIST            default is [ wsl-k8s ]

"

  exit
}

if ($args[0] -eq 'config') {
  notepad.exe $HOME\.wslconfig

  exit
}

$EXEC_CMD_DIR = pwd

$deb = "linux-headers-${kernelversion}-microsoft-standard-WSL2_$(${kernelversion}.split('-')[0])-1_amd64.deb"

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

_downloader "kernel-${kernelversion}-microsoft-standard-WSL2.img" "https://github.com/khs1994/WSL2-Linux-Kernel/releases/download/${kernelversion}-microsoft-standard-WSL2/kernel-${kernelversion}-microsoft-standard-WSL2.img"
_downloader $deb "https://github.com/khs1994/WSL2-Linux-Kernel/releases/download/${kernelversion}-microsoft-standard-WSL2/$deb"

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
