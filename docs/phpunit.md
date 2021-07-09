# PHPUnit in Docker + PHPStorm 最佳实践

按照 [步骤](command.md) 将命令加入 `PATH`

## 命令行使用 PHPUnit

```bash
$ cd my_php_project

$ lnmp-composer require phpunit/phpunit

# $ lnmp-composer install

# 项目根目录编写 PHPUnit 配置文件 phpunit.xml

$ lnmp-phpunit

# 或者将测试命令写到 composer 文件中，通过执行 composer 命令进行测试
# $ lnmp-composer test
```

## 在 PHPStorm 中使用 PHPUnit

请查看 [LNMP 容器化最佳实践](https://github.com/khs1994-docker/php-demo#6-cli-settings)
