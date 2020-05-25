Function Get-SHA256([string]$file) {
  if ($IsWindows) {
    return (certutil -hashfile $file SHA256).split()[4]
  }

  if ($IsMacOS) {
    return (shasum -a 256 $file | cut -d ' ' -f 1)
  }

  return (sha256sum $file | cut -d ' ' -f 1)
}

Function Get-SHA384([string]$file) {
  if ($IsWindows) {
    return (certutil -hashfile $file SHA384).split()[4]
  }

  if ($IsMacOS) {
    return (shasum -a 384 $file | cut -d ' ' -f 1)
  }

  return (sha384sum $file | cut -d ' ' -f 1)
}

Function Get-SHA512([string]$file) {
  if ($IsWindows) {
    return (certutil -hashfile $file SHA512).split()[4]
  }

  if ($IsMacOS) {
    return (shasum -a 512 $file | cut -d ' ' -f 1)
  }

  return (sha512sum $file | cut -d ' ' -f 1)
}
