$tips="You MUST edit $HOME\.wslconfig to custom kernel path, please see $HOME\lnmp\wsl2\conf\.wslconfig"

if($args.Length -eq 0){
  "WSL2 kernel download/update tool

$tips

COMMAND:

download  download kernel only
install   install linux-headers to WSL2

"

exit
}

$source=pwd

$kernelversion="4.19.104"
$deb="linux-headers-${kernelversion}-microsoft-standard_${kernelversion}-1_amd64.deb"

mkdir -f ~/.wsl | out-null

cd ~/.wsl


Function _downloader($name,$url){
  if (Test-Path $name){
    "==> $name exists, skip download"

    return
  }
  "==> download $name"
  curl.exe -fL $url -O
}

# 下载文件

_downloader "kernel-${kernelversion}-microsoft-standard.img" "https://github.com/khs1994/WSL2-Linux-Kernel/releases/download/${kernelversion}-microsoft-standard/kernel-${kernelversion}-microsoft-standard.img"
_downloader $deb "https://github.com/khs1994/WSL2-Linux-Kernel/releases/download/${kernelversion}-microsoft-standard/linux-headers-${kernelversion}-microsoft-standard_${kernelversion}-1_amd64.deb"

# 复制配置文件

if(!(Test-Path $home/.wslconfig)){
  cp $PSScriptRoot/../config/.wslconfig $home/.wslconfig
}

if ($args[0] -eq 'download'){
  cd $source
  Write-Warning $tips
  exit
}

# linux-headers
echo "==> install linux-headers"

wsl -u root dpkg -i $deb

cd $source

Write-Warning $tips
