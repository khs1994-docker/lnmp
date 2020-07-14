# Docker 桌面版 + vsCode 远程开发

* https://docs.docker.com/docker-for-windows/wsl/#best-practices

1. 参照 README.md 准备一节（安装好 vsCode 远程扩展，启动 khs1994-docker/lnmp)

2. 新建空白文件夹，并将 `.devcontainer` `docker-workspace.yml` 复制进来。(或者执行 `$ lnmp-docker vscode-remote`)

**修改 `docker-workspace.yml`**

```yaml
# 注释掉以下两个数据卷
# - ./:/app/demo
# - vendor:/app/demo/vendor

# 取消注释以下数据卷
- /var/lib/app/demo:/app/demo
```

**创建数据卷**

```bash
$ docker volume create lnmp_composer-cache-data
$ docker volume create lnmp_npm-cache-data
```

3. `$ code .` 打开新建的文件夹，调整配置

4. 按 `F1`键（或者点击左下角【打开远程窗口】）, select `Remote-Containers: Reopen in Container`，此时 vsCode 左侧文件列表为空

5. [vsCode 终端] `$ composer create-project --prefer-dist laravel/laravel .` 安装 Laravel，安装完毕后此时 vsCode 左侧文件列表出现文件（或者在 [vsCode 终端] git clone 已有项目）

6. 调整 `.env`

7. [vsCode 终端] 执行 `$ php artisan`

8. 在 `khs1994-docker/lnmp` 中配置 NGINX，浏览器访问项目

**前端配置**

9. [vsCode 终端] `$ composer require laravel/ui` `$ php artisan ui vue`

10. [Windows 终端] `$ docker-compose -f docker-workspace.yml run --rm npm install` (或者执行 `$ lnmp-docker vscode-remote-run npm install`)

11. 参照 https://github.com/khs1994-docker/laravel-demo/tree/master/.test 将示例放入项目

12. [Windows 终端] 编译项目 `$ docker-compose -f docker-workspace.yml run --rm npm run dev` (或者执行 `$ lnmp-docker vscode-remote-run npm run dev`)

13. 访问 IP/test/view

## 总结

* 项目文件存储在 WSL2 中，不存在跨主机问题，故文件性能不存在问题（缺点：1. 若 WSL2 崩溃，项目文件可能丢失 2. WSL2 磁盘空间占用会逐步加大）
