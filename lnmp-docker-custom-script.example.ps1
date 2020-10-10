function __lnmp_custom_init() {
  write-host ''
}

function __lnmp_custom_backup() {
  write-host ''
}

function __lnmp_custom_restore() {
  write-host ''
}

function __lnmp_custom_cleanup() {
  write-host ''
}

function __lnmp_custom_up() {
  write-host ''
}

function __lnmp_custom_down() {
  write-host ''
}

function __lnmp_custom_pull() {
  write-host ''
}

function __lnmp_custom_restart() {
  write-host ''
}

# 当执行不存在的命令时会调用该函数 `lnmp-dcker no-found-cmd`
function __lnmp_custom_command() {
  write-host "command [" $args "] not found"

  # please handle your custom command
}
