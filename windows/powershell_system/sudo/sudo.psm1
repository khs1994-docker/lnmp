Function _sudo($command){
Start-Process powershell -Verb runAs -argumentlist '-NoExit', "cd '$pwd';$command" -wait
}
