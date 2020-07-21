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

    tar -zxvf $dist -C $lrew_dist
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
