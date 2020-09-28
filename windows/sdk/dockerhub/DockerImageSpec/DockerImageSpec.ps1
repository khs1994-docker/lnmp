class DockerImageSpec {
  static [string]$manifest_list = "application/vnd.docker.distribution.manifest.list.v2+json"
  static [string]$manifest = "application/vnd.docker.distribution.manifest.v2+json"
  static [string]$container_config = "application/vnd.docker.container.image.v1+json"
  static [string]$layer = "application/vnd.docker.image.rootfs.diff.tar.gzip"
}
