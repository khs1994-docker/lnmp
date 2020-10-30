## 为什么要编译 WSL2 内核

**由于部分必需模块默认没有编译，所以我们必须自定义 WSL2 内核。**

### `kube-proxy` ipvs 模式

* https://github.com/kubernetes/kubernetes/tree/master/pkg/proxy/ipvs
* https://github.com/khs1994/WSL2-Linux-Kernel

由于 `kube-proxy` 通过检测 `/lib/modules/$(uname -r)/modules.builtin` 文件决定是否启用 `ipvs` 模式.日志如下

```bash
W1012 17:07:44.429803    7184 proxier.go:584] Failed to read file /lib/modules/4.19.72-microsoft-standard/modules.builtin with error open /lib/modules/4.19.72-microsoft-standard/modules.builtin: no such file or directory. You can ignore this message when kube-proxy is running inside container without mounting /lib/modules

I1012 17:07:44.441990    7184 server_others.go:149] Using iptables Proxier.
```

而 WSL2 不包含该文件,故 `kube-proxy` 会回退到 iptables 模式

**第一种方法:** 按照接下来的步骤,通过自己编译 WSL2 内核,并增加该文件, 让 `kube-proxy` 使用 `ipvs` 模式.

**第二种方法:** 直接新建 `/lib/modules/$(uname -r)/modules.builtin` 文件，文件内容到 https://github.com/khs1994/WSL2-Linux-Kernel/releases `Assets` 查看

### CNI Calico eBPF(内核 v5.3+)

## 自己编译

* https://github.com/khs1994/WSL2-Linux-Kernel/blob/master/.github/workflows/ci.yaml

请参考 Actions 文件自行编译,或者直接下载安装

## 下载安装

1. 进入 https://github.com/khs1994/WSL2-Linux-Kernel/releases
2. 在 `Assets`，下载如下两个文件，例如：`kernel-5.4.51-microsoft-standard-WSL2.img` `linux-headers-5.4.51-microsoft-standard-WSL2_5.4.51-1_amd64.deb`
3. 停止 WSL2 `$ wsl --shutdown`
4. 将 `kernel-5.4.51-microsoft-standard-WSL2.img` 放到家目录 `.wsl` 文件夹内(`$home/.wsl`),在 Windows `~/.wslconfig` 中配置 kernel 路径。具体请查看 `~/lnmp/wsl2/config/.wslconfig`
5. 在 `WSL2` 安装 `linux-headers-5.4.51-microsoft-standard-WSL2_5.4.51-1_amd64.deb` (`$ wsl -d wsl-k8s -u root -- dpkg -i linux-headers-5.4.51-microsoft-standard-WSL2_5.4.51-1_amd64.deb`)

**或者直接执行 `$ ~/lnmp/wsl2/bin/kernel`**
