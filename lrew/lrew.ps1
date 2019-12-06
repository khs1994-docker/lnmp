get-command wsl -ErrorAction ignore

if(!$?){
  Write-Warning "WSL not found, please install WSL first"

  exit
}

$command,$pkg,$_=$args

switch ($command) {
  add {
    $lrew_dist="$PSScriptRoot/../vendor/lrew2/$pkg"

    if(Test-Path $lrew_dist){
      Write-Warning "[ $pkg ] already install"

      exit
    }

    . $PSScriptRoot/../windows/sdk/dockerhub/rootfs.ps1
    $dist=rootfs lrewpkg/$pkg latest

    $dist_on_wsl=wsl -- wslpath "'$dist'"
    $lrew_dist_on_wsl=wsl -- wslpath "'$lrew_dist'"

    wsl -- mkdir -p $lrew_dist_on_wsl
    wsl -- tar -zxvf $dist_on_wsl -C $lrew_dist_on_wsl
  }
  Default {
    write-host "
init
add
backup
update
    "
  }
}
