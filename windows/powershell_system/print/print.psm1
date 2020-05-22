Function printInfo($str){
  write-host "==> $str" -ForegroundColor Blue
}

Function printWarning($str){
  write-host "==> $str" -ForegroundColor Yellow
}

Function printError($str){
  write-host "==> $str" -ForegroundColor Red
}
