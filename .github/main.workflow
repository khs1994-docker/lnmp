workflow "Sync Git" {
  on = "push"
  resolves = ["docs-build","sync-docs","action-when","sync-php-demo","sync-node-demo","sync-kubernetes","sync-ci","sync-acme"]
}

action "action-when" {
  uses = "./.github/actions/when/"
  env = {
    PCIT_WHEN_BRANCH="19.03"
    PCIT_WHEN_COMMIT_MESSAGE="1"
    PCIT_WHEN_COMMIT_MESSAGE_SKIP="skip sync"
  }
}

action "docs-build" {
  uses = "docker://pcit/vuepress"
  needs = ["action-when"]
  args = "build"
  env = {
    PCIT_LOCAL_DIR = "docs"
  }
}

action "sync-docs" {
  uses = "docker://pcit/pages"
  secrets = ["PCIT_GIT_TOKEN"]
  needs = ["docs-build"]
  env = {
    PCIT_USERNAME = "khs1994"
    PCIT_EMAIL = "khs1994@khs1994.com"
    PCIT_TARGET_BRANCH = "master"
    PCIT_GIT_URL = "github.com/khs1994-docker/lnmp-docs"
    PCIT_LOCAL_DIR = "docs/.vuepress/dist"
    PCIT_KEEP_HISTORY = "1"
    PCIT_MESSAGE = "Build docs by vuepress, Upload docs by PCIT"
  }
}

action "sync-php-demo" {
  uses = "docker://pcit/pages"
  secrets = ["PCIT_GIT_TOKEN"]
  needs = ["action-when"]
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
  needs = ["action-when"]
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

action "sync-kubernetes" {
  uses = "docker://pcit/pages"
  needs = ["action-when"]
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

action "sync-ci" {
  uses = "docker://pcit/pages"
  needs = ["action-when"]
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
  needs = ["action-when"]
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

action "sync-php" {
  uses = "docker://pcit/pages"
  needs = ["action-when-sync-php"]
  secrets = ["PCIT_GIT_TOKEN"]
  env = {
    PCIT_USERNAME = "khs1994"
    PCIT_EMAIL = "khs1994@khs1994.com"
    PCIT_TARGET_BRANCH = "master"
    PCIT_GIT_URL = "github.com/khs1994-docker/php"
    PCIT_LOCAL_DIR = "dockerfile/php-fpm"
    PCIT_KEEP_HISTORY = "1"
    PCIT_MESSAGE = "Sync from khs1994-docker/lnmp by PCIT"
  }
}

workflow "Sync PHP" {
   on = "push"
   resolves = ["action-when-sync-php","sync-php"]
}

action "action-when-sync-php" {
  uses = "./.github/actions/when/"
  env = {
    PCIT_WHEN_BRANCH="19.03-pre"
    PCIT_WHEN_COMMIT_MESSAGE="1"
    PCIT_WHEN_COMMIT_MESSAGE_INCLUDE="sync php"
  }
}
