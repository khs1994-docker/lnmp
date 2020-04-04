$env:DOCKER_WINDOWS_CONTAINERD_RUNTIME=1

& "C:\Program Files\Docker\Docker\resources\dockerd.exe" `
--containerd \\.\\pipe\\containerd-containerd `
--debug `
--config-file $PSScriptRoot\etc\docker\daemon.json `
