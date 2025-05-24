* https://docs.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_install_firstuse

## 安装

```powershell
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

Name  : OpenSSH.Client~~~~0.0.1.0
State : NotPresent

Name  : OpenSSH.Server~~~~0.0.1.0
State : NotPresent

# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

## 离线安装

* https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_server_configuration
* https://github.com/PowerShell/Win32-OpenSSH/wiki/Install-Win32-OpenSSH

## 启动

```powershell
# Start the sshd service
Start-Service sshd

# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}
```

### 客户端密钥生成

```powershell
& $env:ProgramFiles\OpenSSH-Win64\ssh-keygen -t ed25519

Get-Service ssh-agent | Set-Service -StartupType Automatic

Start-Service ssh-agent

& $env:ProgramFiles\OpenSSH-Win64\ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

### 客户端公钥放置到服务器

#### 标准账户 `C:\Users\username\.ssh\authorized_keys`

#### 管理员账户 `C:\ProgramData\ssh\administrators_authorized_keys`

```powershell
icacls.exe "C:\ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
```

```powershell
# 以管理员权限运行
notepad C:\ProgramData\ssh\administrators_authorized_keys
```

### 配置只允许公钥登录

* C:\ProgramData\ssh\sshd_config

```powershell
# 以管理员权限运行
echo 'AuthenticationMethods publickey' >> C:\ProgramData\ssh\sshd_config
# AuthenticationMethods password
```
