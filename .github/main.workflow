workflow "Sync Git" {
  on = "push"
  resolves = ["sync-php-demo","sync-node-demo","sync-kubernetes-demo","sync-ci-demo","sync-acme"]
}

action "sync-php-demo" {
  uses = "docker://pcit/pages"
  secrets = ["PCIT_GIT_TOKEN"]
  env = {
    PCIT_USERNAME = "khs1994"
    PCIT_EMAIL = "khs1994@khs1994.com"
    PCIT_TARGET_BRANCH = "master"
    PCIT_GIT_URL = "github.com/khs1994-docker/php-demo"
    PCIT_LOCAL_DIR = "app/demo"
    PCIT_KEEP_HISTORY = "1"
    PCIT_MESSAGE = "Sync from khs1994-docker/lnmp by PCIT"
  }
}

action "sync-node-demo" {
  uses = "docker://pcit/pages"
  secrets = ["PCIT_GIT_TOKEN"]
  env = {
    PCIT_USERNAME = "khs1994"
    PCIT_EMAIL = "khs1994@khs1994.com"
    PCIT_TARGET_BRANCH = "master"
    PCIT_GIT_URL = "github.com/khs1994-docker/node-demo"
    PCIT_LOCAL_DIR = "app/node-demo"
    PCIT_KEEP_HISTORY = "1"
    PCIT_MESSAGE = "Sync from khs1994-docker/lnmp by PCIT"
  }
}

action "sync-kubernetes-demo" {
  uses = "docker://pcit/pages"
  secrets = ["PCIT_GIT_TOKEN"]
  env = {
    PCIT_USERNAME = "khs1994"
    PCIT_EMAIL = "khs1994@khs1994.com"
    PCIT_TARGET_BRANCH = "master"
    PCIT_GIT_URL = "github.com/khs1994-docker/lnmp-k8s"
    PCIT_LOCAL_DIR = "kubernetes"
    PCIT_KEEP_HISTORY = "1"
    PCIT_MESSAGE = "Sync from khs1994-docker/lnmp by PCIT"
  }
}

action "sync-ci-demo" {
  uses = "docker://pcit/pages"
  secrets = ["PCIT_GIT_TOKEN"]
  env = {
    PCIT_USERNAME = "khs1994"
    PCIT_EMAIL = "khs1994@khs1994.com"
    PCIT_TARGET_BRANCH = "master"
    PCIT_GIT_URL = "github.com/khs1994-docker/ci"
    PCIT_LOCAL_DIR = "drone"
    PCIT_KEEP_HISTORY = "1"
    PCIT_MESSAGE = "Sync from khs1994-docker/lnmp by PCIT"
  }
}

action "sync-acme" {
  uses = "docker://pcit/pages"
  secrets = ["PCIT_GIT_TOKEN"]
  env = {
    PCIT_USERNAME = "khs1994"
    PCIT_EMAIL = "khs1994@khs1994.com"
    PCIT_TARGET_BRANCH = "master"
    PCIT_GIT_URL = "github.com/khs1994-docker/acme-docker"
    PCIT_LOCAL_DIR = "dockerfile/acme"
    PCIT_KEEP_HISTORY = "1"
    PCIT_MESSAGE = "Sync from khs1994-docker/lnmp by PCIT"
  }
}
