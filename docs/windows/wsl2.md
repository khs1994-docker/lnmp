# WSL2

* https://docs.microsoft.com/en-us/windows/wsl/compare-versions#expanding-the-size-of-your-wsl-2-virtual-hardware-disk

## 在 Windows 端 Docker 挂载 WSL2 中的文件

```powershell
$ docker run -it --rm -v \\wsl$\ubuntu:/tmp alpine ls -la /tmp

$ docker run -it --rm -v \\wsl\ubuntu:/tmp alpine ls -la /tmp

$ docker run -it --rm -v \\wsl.localhost\ubuntu:/tmp alpine ls -la /tmp

# $ ls \\wsl.localhost\ubuntu
# $ ls \\wsl$\ubuntu
```
