workflow "docs" {
  on = "push"
  resolves = ["docs-build", "docs-sync"]
}

action "docs-build" {
  uses = "docker://pcit/vuepress"
  args = "build"
  env = {
    PCIT_LOCAL_DIR = "docs"
  }
}

action "docs-sync" {
  uses = "docker://pcit/pages"
  needs = ["docs-build"]
  secrets = ["PCIT_GIT_TOKEN"]
  env = {
    PCIT_USERNAME = "khs1994"
    PCIT_EMAIL = "khs1994@khs1994.com"
    PCIT_TARGET_BRANCH = "gh-pages"
    PCIT_GIT_URL = "github.com/khs1994-docker/lnmp-k8s"
    PCIT_LOCAL_DIR = "docs/.vuepress/dist"
    PCIT_KEEP_HISTORY = "1"
    PCIT_MESSAGE = "Build docs by vuepress, Upload docs by PCIT"
  }
}
