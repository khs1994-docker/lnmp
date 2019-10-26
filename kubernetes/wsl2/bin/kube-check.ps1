wsl -- sh -c "df -h | grep '/wsl/k8s-data'"

# k8s-data 未挂载
if(!$?){
  # k8s-data 是否安装
  wsl -d k8s-data -- echo 'k8s-data exists'
  if(!$?){
    "==> k8s-data not found"

    exit 1
  }
  # 检查挂载路径
  wsl -- sh -c "df -h | grep '/c'"

  if(!$?){
    "==> mount is error"

    exit 1
  }
Start-Process -FilePath "wsl" -Argumentlist "-d","k8s-data","--","sh","-c","'while sleep 1000; do : ; done'" -WindowStyle Hidden
}else{
  "==> k8s-data check pass"
}
