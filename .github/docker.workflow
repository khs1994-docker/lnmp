workflow "Docker" {
  on = "push"
  resolves = ["GitHub Action for Docker Version","GitHub Action for Docker Build"]
}

action "GitHub Action for Docker Version" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  args = "version"
  env = {
    DOCKER_BUILDKIT = "1"
  }
}

action "GitHub Action for Docker Build" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["GitHub Action for Docker Version"]
  runs = "docker"
  args = "build --help"
  env = {
    DOCKER_BUILDKIT = "1"
  }
}
