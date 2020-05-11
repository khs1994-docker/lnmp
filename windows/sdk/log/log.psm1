function _error($script, $message) {
  write-host "==> " -NoNewline -ForegroundColor Red
  write-host $script.ScriptName -NoNewline -ForegroundColor Red
  write-host " [ $($script.ScriptLineNumber) ] "-NoNewline -ForegroundColor Yellow
  write-host $message -ForegroundColor Red
  write-host ""
}
