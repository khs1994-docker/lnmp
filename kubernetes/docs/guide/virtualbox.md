# VirtualBox

* https://www.virtualbox.org/
* https://download.virtualbox.org/virtualbox

* 如果使用测试版系统，出现错误，可以尝试测试版的 `VirtualBox`，下载地址已在上方列出。

**virtualbox 国内镜像地址**

* https://mirror.tuna.tsinghua.edu.cn/help/virtualbox/

## 解决错误

```bash
WARNING: The vboxdrv kernel module is not loaded. Either there is no module
         available for the current kernel (5.3.2-300.fc31.x86_64) or it failed to
         load. Please recompile the kernel module and install it by

           sudo /sbin/vboxconfig

         You will not be able to start VMs until this problem is fixed.
```

```bash
$ sudo dnf install kernel-headers make kernel-devel

$ sudo /sbin/vboxconfig
```

## macOS

每次安装后执行如下命令：

```bash
$ sudo "/Library/Application Support/VirtualBox/LaunchDaemons/VirtualBoxStartup.sh" restart
```

如果出现错误，请按如下方法操作，再次执行上述命令：

`System Preferences` -> `Security & Privacy` -> `点击左下角 锁 图标解锁` -> `allow execute kext (modules)`
