net user DockerExchange /add

Remove-SmbShare -Name C -ErrorAction SilentlyContinue -Force
$deUsername = 'DockerExchange'
$dePsw = "ABC" + [guid]::NewGuid().ToString() + "!"
$secDePsw = ConvertTo-SecureString $dePsw -AsPlainText -Force
Get-LocalUser -Name $deUsername | Set-LocalUser -Password $secDePsw
date
& $env:ProgramFiles\Docker\Docker\DockerCli.exe -Start --testftw!928374kasljf039
date
& $env:ProgramFiles\Docker\Docker\DockerCli.exe -Mount=C -Username="$env:computername\$deUsername" -Password="$dePsw" --testftw!928374kasljf039
date
Disable-NetFirewallRule -DisplayGroup "File and Printer Sharing" -Direction Inbound
