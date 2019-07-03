Function _command($command){
  if ($command -eq "wsl"){
    wsl curl -V | out-null
  }else{
    get-command $command -ErrorAction "SilentlyContinue"
  }

  return $?
}
