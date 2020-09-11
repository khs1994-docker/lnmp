# Docker 桌面版(Windows-WSL2) + vsCode 远程开发

* https://docs.docker.com/docker-for-windows/wsl/#best-practices

参考 https://docs.lnmp.khs1994.com/laravel.html **Windows 运行 Laravel 响应缓慢的问题** 小节 vsCode 的说明

## 注意事项

项目文件存储在 WSL2 中，不存在跨主机问题，故文件性能不存在问题。

**缺点：**

1. 若 WSL2 崩溃，项目文件可能丢失

2. WSL2 磁盘空间占用会逐步加大
