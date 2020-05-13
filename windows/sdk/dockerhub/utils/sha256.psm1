Function sha256($file) {
  if ($IsWindows) {
    return (certutil -hashfile $file SHA256).split()[4]
  }

  return (sha256sum $file | cut -d ' ' -f 1)
}
