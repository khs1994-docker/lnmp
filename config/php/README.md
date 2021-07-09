* http://php.net/configuration.file
* http://www.jinbuguo.com/php/php.ini.html

## [sapi](https://github.com/php/php-src/tree/master/sapi)

* cli
* cli-server
* fpm-fcgi
* apache2handler
* cgi
* embed

```ini
; 对于服务器模块，仅在服务器启动时读取一次 php.ini 。对于 CGI 和 CLI ，每次调用都会读取 php.ini 。

; PHP 会在初始化时按如下顺序搜索此文件(搜到即停)：
; 1. SAPI 模块指定的位置：
;     (a) Apache 2.x 中的 PHPIniDir 指令
;     (b) CGI/CLI 模式下 -c 命令行选项
;     (c) NSAPI 中的 php_ini 参数
;     (d) THTTPD 中的 PHP_INI_PATH 环境变量
; 2. PHPRC 环境变量指定的位置
; 3. Windows注册表指定的位置(依次搜索、搜到即停)：
;     (a) [HKEY_LOCAL_MACHINE\SOFTWARE\PHP\x.y.z] 内的 IniFilePath 的值(特定于php-x.y.z版本)
;     (b) [HKEY_LOCAL_MACHINE\SOFTWARE\PHP\x.y] 内的 IniFilePath 的值(特定于php-x.y.*系列版本)
;     (c) [HKEY_LOCAL_MACHINE\SOFTWARE\PHP\x] 内的 IniFilePath 的值(特定于php-x.*.*系列版本)
;     (d) [HKEY_LOCAL_MACHINE\SOFTWARE\PHP] 内的 IniFilePath 的值(不特定于php的版本)
; 4. 当前工作目录(不适用于 CLI 模式)
;    [提示] Apache 会在启动时把当前工作目录转到根目录，这将导致 PHP 可能会尝试在根目录读取 php.ini 。
; 5. web 服务器目录(适用于 SAPI 模块)或 PHP 所在目录(Windows 下其它情况)
; 6. 编译时选项 --with-config-file-path 指定的位置 或 Windows目录( %SystemRoot% 通常是"C:\Windows")

; 如果存在 php-SAPI.ini (例如 php-apache2handler.ini, php-fpm-fcgi.ini, php-cli-server.ini, php-cli.ini 等)，
; 那么 php.ini 将会被 php-SAPI.ini 取代。
```
