# 检查 wsl 是否满足运行 k8s 的需求
wsl -- sh -c "df -h | grep -q '/wsl/k8s-data'"

# k8s-data 未挂载，说明 k8s-data 未处于运行状态或未进行手动挂载
if(!$?){
  # k8s-data 是否安装
  wsl -d k8s-data -- echo '==> WSL2 dist [ k8s-data ] exists'
  if(!$?){
    "==> WSL2 dist [ k8s-data ] not found, please see README.SERVER.md"

    exit 1
  }
  # 检查挂载路径
  wsl -- sh -c "df -h | grep -q '/c'"

  if(!$?){
    "==> mount is error, please check WSL [ /etc/wsl.conf ], and see README.SERVER.md"

    exit 1
  }
  # 运行 k8s-data
  & $PSScriptRoot/wsl2d.ps1
  # 19018 + 不再进行自动挂载，必须手动挂载 k8s-data
  "==> try mount dist [ k8s-data ] to /wsl/k8s-data"
  $dev_sdx=(wsl -d k8s-data -- mount).split(' ')[0]
  wsl -u root -- mkdir -p /wsl/k8s-data
  wsl -u root -- mount $dev_sdx /wsl/k8s-data
  sleep 1
}else{
  "==> WSL2 dist [ k8s-data ] check passed"
}

wsl -- sh -c "df -h | grep -q '/wsl/k8s-data'"

if(!$?){
  Write-Warning "==> dist [ k8s-data ] mount error"

  exit 1
}

# docker desktop check
foreach ($item in $(wsl -l --running)){
  if($item -eq 'docker-desktop'){
    Write-Warning "docker desktop running, exit"

    exit 1
  }
}
