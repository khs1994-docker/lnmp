Function _sudo($command){
  Start-Process powershell -Verb runAs `
    -argumentlist '-NoExit',"-WorkingDirectory","$PWD","-c","$command" -wait
}
