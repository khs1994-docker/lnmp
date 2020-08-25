# wsl-k8s 是否安装
wsl -d wsl-k8s -- echo '==> WSL dist [ wsl-k8s ] exists'
if (!$?) {
  Write-Warning "==> WSL dist [ wsl-k8s ] not found, please see README.SERVER.md"

  exit 1
}

# wsl-k8s-data 的硬盘是否已挂载到 wsl-k8s 的 /wsl/wsl-k8s-data
wsl -d wsl-k8s -- sh -c "mountpoint -q /wsl/wsl-k8s-data"

if (!$?) {
  # wsl-k8s-data 未挂载，说明 wsl-k8s-data 未处于运行状态或未进行手动挂载
  # wsl-k8s-data 是否安装
  wsl -d wsl-k8s-data -- echo '==> WSL dist [ wsl-k8s-data ] exists'
  if (!$?) {
    Write-Warning "==> WSL dist [ wsl-k8s-data ] not found, please see README.SERVER.md"

    exit 1
  }
  # 检查挂载路径
  wsl -d wsl-k8s -- sh -c "mountpoint -q /c"

  if (!$?) {
    Write-Warning "==> mount is error, please check WSL dist (wsl-k8s) [ /etc/wsl.conf ], please see README.SERVER.md"

    exit 1
  }
  # 运行一个进程，保持 wsl-k8s-data 不自动推出
  & $PSScriptRoot/wsl2d.ps1
  # 在 wsl-k8s 挂载 wsl-k8s-data
  write-host "==> try mount WSL dist [ wsl-k8s-data ] to [ wsl-k8s ] /wsl/wsl-k8s-data" -ForegroundColor Green
  $dev_sdx = (wsl -d wsl-k8s-data -- mount).split(' ')[0]
  wsl -d wsl-k8s -u root -- mkdir -p /wsl/wsl-k8s-data
  write-host "==> wsl-k8s-data DISK is $dev_sdx" -ForegroundColor Green
  wsl -d wsl-k8s -u root -- mount $dev_sdx /wsl/wsl-k8s-data
  sleep 1
}
else {
  write-host "==> WSL dist [ wsl-k8s-data ] disk already mount to [ wsl-k8s ]" -ForegroundColor Green
}

wsl -d wsl-k8s -- sh -c "mountpoint -q /wsl/wsl-k8s-data"

if (!$?) {
  Write-Warning "==> WSL dist [ wsl-k8s-data ] mount error"

  exit 1
}

try {
  ls \\wsl$\wsl-k8s\wsl\wsl-k8s-data\k8s\bin | out-null
}
catch {
  Write-Warning "==> WSL dist [ wsl-k8s-data ] [ /k8s/bin ] not found, mount error OR not install k8s"

  # exit 1
}

# docker desktop check
foreach ($item in $(wsl -l --running)) {
  if ($item -eq 'docker-desktop') {
    Write-Warning "docker desktop running, exit"

    exit 1
  }
}

wsl -d wsl-k8s -u root -- mount --make-shared /
