Import-Module downloader
Import-Module unzip

Function install($VERSION="1.02.1907102",$preVersion=0){
  if($preVersion){

  }
  $url="https://dldir1.qq.com/WechatWebDev/nightly/p-7aa88fbb60d64e4a96fac38999591e31/wechat_devtools_${VERSION}_x64.exe"
  $name="WeChat Devtool"
  $filename="wechat_devtools_${VERSION}_x64.exe"
  $unzipDesc="wechat_devtools"

  # 下载原始 zip 文件，若存在则不再进行下载
  _downloader `
    $url `
    $filename `
    $name `
    $VERSION

  # 验证原始 zip 文件 Fix me

  # 解压 zip 文件 Fix me
  # _unzip $filename $unzipDesc
  # 安装 Fix me
  # Copy-item "" ""

  Start-Process -FilePath $filename -wait

  echo "==> Checking ${name} ${VERSION} install ..."
  # 验证 Fix me
  & 'C:\Program Files (x86)\Tencent\微信web开发者工具\cli.bat' --version
}

Function uninstall(){
  & 'C:\Program Files (x86)\Tencent\微信web开发者工具\卸载微信开发者工具.exe'
}
