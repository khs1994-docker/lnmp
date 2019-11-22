# `kube-proxy` ipvs 模式(为什么要编译 WSL2 内核)

* https://github.com/kubernetes/kubernetes/tree/master/pkg/proxy/ipvs
* https://github.com/khs1994/WSL2-Linux-Kernel

由于 `kube-proxy` 通过检测 `/lib/modules/$(uname -r)/modules.builtin` 文件决定是否启用 `ipvs` 模式.日志如下

```bash
W1012 17:07:44.429803    7184 proxier.go:584] Failed to read file /lib/modules/4.19.72-microsoft-standard/modules.builtin with error open /lib/modules/4.19.72-microsoft-standard/modules.builtin: no such file or directory. You can ignore this message when kube-proxy is running inside container without mounting /lib/modules

I1012 17:07:44.441990    7184 server_others.go:149] Using iptables Proxier.
```

而 WSL2 不包含该文件,故 `kube-proxy` 会回退到 iptables 模式

**第一种方法:** 按照接下来的步骤,通过自己编译 WSL2 内核,并增加该文件, 让 `kube-proxy` 使用 `ipvs` 模式.

**第二种方法:** 直接新建 `/lib/modules/$(uname -r)/modules.builtin` 文件，文件内容到 `下载安装` 的第 3 步查看 **未尝试**

## 自己编译

* https://github.com/khs1994/WSL2-Linux-Kernel/blob/master/.github/workflows/ci.yaml

请参考 Actions 文件自行编译,或者直接下载安装

## 下载安装

1. 进入 https://github.com/khs1994/WSL2-Linux-Kernel/actions
2. 进入构建结果
3. 右上角 `Artifacts`,点击下载
4. 停止 WSL2 `$ wsl --shutdown`
5. 解压之后,将 `wsl2Kernel` 放到家目录,在 Windows `~/.wslconfig` 中配置 kernel 路径.具体请查看 `~/lnmp/wsl2/config/.wslconfig`
6. 将 `linux.tar.gz` 解压到 `WSL2` (`$ wsl -u root -- tar -zxvf linux.tar.gz -C /`)

**或者直接执行 `$ ~/lnmp/wsl2/bin/kernel`**
