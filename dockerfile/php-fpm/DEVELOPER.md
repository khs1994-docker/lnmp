# 开发者必读

## 发布流程

### 1. 桌面版构建 arm FPM 镜像

```bash
$ ./scripts/arm-build.sh build 7.3.6 arm32v7 7.3/alpine fpm
$ ./scripts/arm-build.sh build 7.3.6 arm64v8 7.3/alpine fpm
```

### 2. 同步到 `khs1994-docker/php` CI 构建镜像

### 3. 桌面版构建 arm composer 镜像

```bash
$ ./scripts/arm-build.sh build 7.3.6 arm32v7 7.3/composer composer
$ ./scripts/arm-build.sh build 7.3.6 arm64v8 7.3/composer composer
```

### 4. CI 重新构建 composer 镜像
