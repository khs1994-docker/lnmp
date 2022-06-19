function __lnmp_custom_init() {

}

function __lnmp_custom_backup() {

}

function __lnmp_custom_restore() {

}

function __lnmp_custom_cleanup() {

}

function __lnmp_custom_pre_up() {
  wsl -d docker-desktop sh -cx `
    'chown root:root config/mysql/conf.d/my.cnf; \
     chmod 644       config/mysql/conf.d/my.cnf; \
     chown root:root config/mariadb/conf.d/my.cnf; \
     chmod 644       config/mariadb/conf.d/my.cnf;
    '
}

function __lnmp_custom_post_up() {

}

function __lnmp_custom_post_down() {

}

function __lnmp_custom_post_pull() {

}

function __lnmp_custom_restart() {

}

# 当执行不存在的命令时会调用该函数 `lnmp-dcker no-found-cmd`
function __lnmp_custom_command() {
  write-host "command [" $args "] not found"

  # please handle your custom command
}
