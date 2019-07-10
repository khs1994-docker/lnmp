Function _mkdir($dir_path){
  if (!(Test-Path $dir_path )){
    New-Item $dir_path -type directory | out-null
  }
}
