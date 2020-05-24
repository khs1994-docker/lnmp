Function printInfo() {
  write-host "==> $args" -ForegroundColor Blue
}

Function printWarning() {
  write-host "==> $args" -ForegroundColor Yellow
}

Function printError() {
  write-host "==> $args" -ForegroundColor Red
}

Function printTips() {
  write-host "==> $args" -ForegroundColor Green
}
