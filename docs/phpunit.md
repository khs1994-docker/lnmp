# PHPUnit in Docker + PHPStorm 最佳实践

[![](https://img.shields.io/badge/AD-%E8%85%BE%E8%AE%AF%E4%BA%91%E5%AE%B9%E5%99%A8%E6%9C%8D%E5%8A%A1-blue.svg)](https://cloud.tencent.com/act/cps/redirect?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61) [![](https://img.shields.io/badge/Support-%E8%85%BE%E8%AE%AF%E4%BA%91%E8%87%AA%E5%AA%92%E4%BD%93-brightgreen.svg)](https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh)

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
