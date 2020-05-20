Function sha512([string]$file) {
  if ($IsWindows) {
    return (certutil -hashfile $file SHA512).split()[4]
  }

  return (sha512sum $file | cut -d ' ' -f 1)
}
