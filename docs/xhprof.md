# XHProf

* https://github.com/tideways/php-xhprof-extension

## 启用扩展

编辑 `./config/php/docker-php.ini` 文件

```bash
extension=tideways_xhprof.so
```

## 使用

```php
<?php

tideways_xhprof_enable();

my_application();

file_put_contents(
    sys_get_temp_dir() . DIRECTORY_SEPARATOR . uniqid() . '.myapplication.xhprof',
    serialize(tideways_xhprof_disable())
);
```
