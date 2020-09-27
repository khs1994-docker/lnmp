class OCIImageSpec {
  static [string]$manifest_list = "application/vnd.oci.image.index.v1+json"
  static [string]$manifest = "application/vnd.oci.image.manifest.v1+json"
  static [string]$container_config = "application/vnd.oci.image.config.v1+json"
  static [string]$layer_tar = "application/vnd.oci.image.layer.v1.tar"
  static [string]$layer_tar_gz = "application/vnd.oci.image.layer.v1.tar+gzip"
  static [string]$layer_tar_zstd = "application/vnd.oci.image.layer.v1.tar+zstd"
}
