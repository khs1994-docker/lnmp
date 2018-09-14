# Windows Hyperv 使用 minikube

Windows 10 在 Hyper-V 虚拟机中运行 Minikube

首先建立一个外部虚拟交换机 `minikube`，并绑定真实的网卡。

具体图解请看 https://yq.aliyun.com/articles/221687

### 安装及启动

管理员身份打开 **系统自带** 的 `PowerShell`

```bash
$ ./lnmp-k8s.ps1 minikue-install

# 移动 minikube.exe 文件到 PATH

$ ./lnmp-k8s.ps1 minikube

$ ./lnmp-k8s.ps1 create
```

```bash
$ (( Get-VM minikube ).networkadapters[0]).ipaddresses[0]
```

此命令在系统自带的 `PowerShell` 中执行，会获取到 `minikube` 虚拟机 IP.
