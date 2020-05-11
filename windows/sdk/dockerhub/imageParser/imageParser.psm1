# 地址 地址+端口 | 用户名 无用户名 | 镜像 | 标签 无标签

# docker.io docker.io:9000 library - golang latest -

# 12 - 4 = 8
# $env:SOURCE_DOCKER_REGISTRY=
# $env:DEST_DOCKER_REGISTRY = "default.dest.ccs.tencentyun.com"

Function imageParser([string] $config, [boolean] $source = $true) {
  # host:port/user/image:ref
  # host:port/image:ref -
  if ($config.split(':').count -eq 3) {
    $_registry, $port_plus_image, $ref = $config.split(':')
    $image = "${_registry}:${port_plus_image}"
  }
  # host:port/user/image
  # host:port/image -
  # user/image:ref
  # host/image:ref -
  # host/user/image:ref
  # image:ref
  elseif ($config.split(':').count -eq 2) {
    if (!($config.contains('/'))) {
      # image:ref
      $image, $ref = $config.split(':')
    }
    else {
      $image, $ref = $config.split(':')
      if ($image.contains('/')) {
        # host/user/image:ref
        # user/image:ref
      }
      else {
        # host:port/user/image
        $_registry, $port_plus_image = $config.split(':')
        $port, $image = $port_plus_image.split('/', 2)
        $registry = "${_registry}:${port}"
        $ref = $null
      }
    }
  }
  # image
  # host/image -
  # user/image
  # host/user/image
  else {
    $image, $ref = $config.split(':')
    if ($config.split('/') -eq 3) {
      $registry, $image = $config.aplit('/', 2)
    }
  }

  if ($image.split('/').Count -ge 3 ) {
    $registry, $image = $image.split('/', 2)
  }
  else {
    if (!$registry) {
      if ($source) {
        $registry = $env:SOURCE_DOCKER_REGISTRY
      }
      else { $registry = $env:DEST_DOCKER_REGISTRY }
    }
  }

  if (!$image.contains('/')) {
    $image = "library/$image"
  }

  # default source registry
  if (!$registry -and $source) {
    $registry = 'hub-mirror.c.163.com'
  }

  if (!$ref) { $ref = "latest" }

  if (!$registry) {
    write-host `
      "==> [error] [ $config ] parse error, `$env:DEST_DOCKER_REGISTRY NOT set" `
      -ForegroundColor DarkRed # DarkGray # Magenta # Cyan
  }

  write-host (Convertfrom-Json -InputObject @"
  {
      "registry": "$registry",
      "image": "$image",
      "ref":"$ref"
  }
"@) -ForegroundColor Red

  return $registry, $image, $ref
}

Export-ModuleMember -Function imageParser
