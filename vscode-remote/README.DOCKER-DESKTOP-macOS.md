# Docker 桌面版(macOS) + vsCode 远程开发

1. vsCode 安装远程扩展

```bash
$ code --install-extension ms-vscode-remote.remote-containers
```

2. 新建空白文件夹或在已有项目中将 `.devcontainer` `docker-workspace.yml` 复制进来(或者执行 `$ lnmp-docker code-init`) 并根据实际进行调整。

**创建数据卷**

```bash
$ docker volume create lnmp_composer-cache-data
$ docker volume create lnmp_npm-cache-data
```

3. 在项目文件夹下执行 `$ code .` 打开 vsCode，调整配置

4. 按 `F1`键（或者点击左下角【打开远程窗口】）, select `Remote-Containers: Reopen in Container`，此时 vsCode 左侧文件列表为空

5. [vsCode 终端] `$ composer create-project --prefer-dist laravel/laravel .` 安装 Laravel，安装完毕后此时 vsCode 左侧文件列表出现文件（或者在 [vsCode 终端] git clone 已有项目）

6. 调整 `.env`

7. [vsCode 终端] 执行 `$ php artisan`

8. 在 `khs1994-docker/lnmp` 中配置 NGINX，浏览器访问项目

**前端配置**

9. [vsCode 终端] `$ composer require laravel/ui` `$ php artisan ui vue`

10. [macOS 终端] `$ docker-compose -f docker-workspace.yml run --rm npm install` (或者执行 `$ lnmp-docker code-run npm install`)

11. 参照 https://github.com/khs1994-docker/laravel-demo/tree/master/.test 将示例放入项目

12. [macOS 终端] 编译项目 `$ docker-compose -f docker-workspace.yml run --rm npm run dev` (或者执行 `$ lnmp-docker code-run npm run dev`)

13. 访问 http://IP/test/view
