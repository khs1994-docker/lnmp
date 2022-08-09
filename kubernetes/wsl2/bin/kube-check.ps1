. $PSScriptRoot/../.env.ps1

if (!$MountPhysicalDiskType2WSL2) {
  $MountPhysicalDiskType2WSL2 = "ext4"
}

# wsl-k8s 是否安装
wsl -d wsl-k8s -- echo '==> WSL2 dist [ wsl-k8s ] exists'
if (!$?) {
  Write-Warning "==> WSL2 dist [ wsl-k8s ] not found, please see README.SERVER.md"

  exit 1
}

# 检查挂载路径
wsl -d wsl-k8s -- sh -c "mountpoint -q /c"

if (!$?) {
  Write-Warning "==> WSL2 Windows disk mount point is not / , please check WSL2 dist (wsl-k8s) [ /etc/wsl.conf ], please see README.SERVER.md"

  exit 1
}

# 如果挂载物理硬盘先检查物理硬盘是否挂载
if ($MountPhysicalDiskDeviceID2WSL2 -and $MountPhysicalDiskPartitions2WSL2) {
  # "\\.\PHYSICALDRIVE1" ==> "PHYSICALDRIVE1"
  $MountPhysicalDiskDeviceID2WSL2Trim = $MountPhysicalDiskDeviceID2WSL2.replace('\', '').replace('.', '')
  $query = "SELECT * from Win32_DiskDrive WHERE DeviceID = '\\\\.\\${MountPhysicalDiskDeviceID2WSL2Trim}'"
  if ((GET-CimInstance -query $query).DeviceID -ne $MountPhysicalDiskDeviceID2WSL2) {
    Write-Warning "==> Disk [ $MountPhysicalDiskDeviceID2WSL2 ] not found, please check disk exists"

    exit 1
  }
  # /wsl/PHYSICALDRIVE1p<n>
  $MountPhysicalDiskDeviceWSL2Path = "/wsl/${MountPhysicalDiskDeviceID2WSL2Trim}p${MountPhysicalDiskPartitions2WSL2}"
  wsl -d wsl-k8s -- sh -c "mountpoint -q $MountPhysicalDiskDeviceWSL2Path"
  if (!$?) {
    Write-Host "==> $MountPhysicalDiskDeviceID2WSL2 not mount to WSL2" -ForegroundColor Red

    wsl -d wsl-k8s -- sh -c "mountpoint -q /wsl/wsl-k8s-data > /dev/null 2>&1 && umount /wsl/wsl-k8s-data || true"
  }
}

# wsl-k8s-data 的硬盘 或 物理硬盘 是否已挂载到 wsl-k8s 的 /wsl/wsl-k8s-data
wsl -d wsl-k8s -- sh -c "mountpoint -q /wsl/wsl-k8s-data"

if (!$?) {
  Write-Host "==> WSL2 dist [ wsl-k8s ] /wsl/wsl-k8s-data isn't mountpoint" -ForegroundColor Yellow
  # 运行一个进程，保持 wsl-k8s 不自动退出
  & $PSScriptRoot/wsl2d.ps1 wsl-k8s
  if ($MountPhysicalDiskDeviceID2WSL2 -and $MountPhysicalDiskPartitions2WSL2) {
    # 挂载物理硬盘
    if (!(Test-Path \\wsl$\wsl-k8s\$MountPhysicalDiskDeviceWSL2Path)) {
      Write-Host "==> Try mount $MountPhysicalDiskDeviceID2WSL2 to WSL2" -ForegroundColor Green
      start-process "wsl" `
        -ArgumentList "--mount", "$MountPhysicalDiskDeviceID2WSL2", "--partition", "$MountPhysicalDiskPartitions2WSL2" `
        -Verb runAs

      sleep 2

      # wsl -d wsl-k8s -u root -- mount -t $MountPhysicalDiskType2WSL2
    }
    else {
      Write-Host "==> $MountPhysicalDiskDeviceID2WSL2 already mount to WSL2, but not mount to WSL2 dist [ wsl-k8s ] /wsl/wsl-k8s-data" -ForegroundColor Green
    }
    $dev_sdx = wsl -d wsl-k8s -- sh -c "mount | grep $MountPhysicalDiskDeviceWSL2Path | cut -d ' ' -f 1"
  }
  else {
    # 不挂载物理硬盘
    # wsl-k8s-data 未挂载
    # 说明 wsl-k8s-data 未处于运行状态或未进行手动挂载

    # wsl-k8s-data WSL2 是否存在
    wsl -d wsl-k8s-data -- echo '==> WSL2 dist [ wsl-k8s-data ] exists'
    if (!$?) {
      Write-Warning "==> WSL2 dist [ wsl-k8s-data ] not found, please see README.SERVER.md"

      exit 1
    }
  }

  if (!($MountPhysicalDiskDeviceID2WSL2 -and $MountPhysicalDiskPartitions2WSL2)) {
    # 运行一个进程，保持 wsl-k8s-data 不自动退出
    & $PSScriptRoot/wsl2d.ps1
    # 在 wsl-k8s 挂载 wsl-k8s-data
    Write-Host "==> Try mount WSL2 dist [ wsl-k8s-data ] to [ wsl-k8s ] /wsl/wsl-k8s-data" -ForegroundColor Green
    $dev_sdx = (wsl -d wsl-k8s-data -- mount -t ext4).split(' ')[0]
    Write-Host "==> WSL2 dist [wsl-k8s-data] Disk is $dev_sdx" -ForegroundColor Green
  }

  if (!$dev_sdx) {
    Write-Host "==> meet error, please re-exec" -ForegroundColor Red
    exit 1
  }

  Write-Host "==> Try mount disk to WSL2 dist [ wsl-k8s ] /wsl/wsl-k8s-data" -ForegroundColor Green
  wsl -d wsl-k8s -u root -- sh -cx "mkdir -p /wsl/wsl-k8s-data"
  wsl -d wsl-k8s -u root -- sh -cx "mount $dev_sdx /wsl/wsl-k8s-data"
  sleep 2
}
else {
  Write-Host "==> WSL2 dist [ wsl-k8s-data ] disk or physical disk already mount to WSL2 dist [ wsl-k8s ] /wsl/wsl-k8s-data" -ForegroundColor Green
}

wsl -d wsl-k8s -- sh -xc "mountpoint -q /wsl/wsl-k8s-data"

if (!$?) {
  Write-Warning "==> WSL2 dist [ wsl-k8s-data ] mount error"

  exit 1
}

wsl -d wsl-k8s -u root -- sh -cx "ls -la /wsl/wsl-k8s-data/k8s/bin > /dev/null"

# docker desktop check
foreach ($item in $(wsl -l --running)) {
  if ($item -eq 'docker-desktop') {
    Write-Warning "docker desktop running, exit"

    exit 1
  }
}

wsl -d wsl-k8s -u root -- sh -cx "mount --make-shared /"
wsl -d wsl-k8s -u root -- sh -cx "mount --make-shared /sys"

& $PSScriptRoot/wsl2host --write
