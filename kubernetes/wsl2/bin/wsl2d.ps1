<#
.DESCRIPTION
  运行一个后台脚本，让 WSL 一直处于运行状态
#>

$DIST = "wsl-k8s-data"

if ($args[0]) {
  $DIST = $args[0]
}

wsl -d $DIST -- ps aux `| grep -w 'sh -c while sleep 1218; do : ; done' `| grep -v grep > $null

if ($?) {
  exit 0
}

Start-Process -FilePath "wsl" -Argumentlist `
  "-d", $DIST, "--", "sh", "-c", "'while sleep 1218; do : ; done'" `
  -WindowStyle Hidden
