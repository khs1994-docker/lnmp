
$sync_config = 0..($(cat manifest.txt).Count - 1)
$i = -1

foreach ($item in $(cat manifest.txt)) {
  $i++

  $source = "php:$item"
  # $dest = "ccr.ccs.tencentyun.com/khs1994/php:$item"
  # $dest = "php:$item"

  $config = @{
    "source" = "$source";
    # "dest"   = "$dest"
  }

  $sync_config[$i] = $config

  ConvertTo-Json -InputObject $sync_config | set-content docker-image-sync.json

  (cat docker-image-sync.json -raw) -replace "`r`n", "`n" | Set-Content -NoNewline docker-image-sync.json
}
