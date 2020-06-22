Function _sudo() {
  Start-Process powershell -Verb runAs `
    -argumentlist '-NoExit', "-c", "$args" -wait
}
