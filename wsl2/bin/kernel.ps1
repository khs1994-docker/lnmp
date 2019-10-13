if($args.Length -eq 0){
  "WSL2 kernel download/update tool

You MUST edit $HOME\.wslconfig to custom kernel path, please see $HOME\lnmp\wsl2\conf\.wslconfig

COMMAND:

download  download kernel
update    update kernel(Expand Archive kernel files to WSL2)

"

exit
}

$artifacts="https://github.com/khs1994/WSL2-Linux-Kernel/suites/263061296/artifacts/119359"
$kernelversion="wsl2-kernel-4.19.75-microsoft-standard+"
$zip="$home/Downloads/$kernelversion.zip"
$unzipFolder="$home/Downloads/$kernelversion"

# 下载文件

Function _downloader(){
  if (Test-Path $zip){
    "==> $zip exists, skip download"

    return
  }
  "==> download $zip"
  curl.exe -fL $artifacts -o $zip
}

_downloader

# 解压
if (Test-Path $unzipFolder){
  "==> $unzipFolder exists, skip unzip"
}else{
  Expand-Archive -Path $zip -DestinationPath $home/Downloads -Force
}

if ($args[0] -eq 'download'){
  exit
}

# 复制文件
$source=PWD
cd "$home/Downloads/$kernelversion"

write-warning "==> Exec: cp wsl2Kernel $home"

try{
cp wsl2Kernel $home

$command="tar -zxvf linux.tar.gz -C /"

write-warning "==> Exec: $command"

wsl -u root -- bash -c $command
cd $source
}catch{
cd $source
}
