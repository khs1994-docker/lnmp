* https://github.com/DamionGans/ubuntu-wsl2-systemd-script

## 不进入 `systemd`

> 执行 `wsl -d wsl-k8s` 不进入 `systemd`

新建 `/non-systemd` 文件

**Windows**

```powershell
$ New-Item \\wsl$\wsl-k8s\non-systemd

# 移除
# $ Remove-Item \\wsl$\wsl-k8s\non-systemd
```

## 针对 `wsl-k8s` WSL2 的优化

* `/wsl/wsl-k8s-data` 未挂载则不进入 systemd

## 类似项目

* https://github.com/yuk7/ArchWSL2
