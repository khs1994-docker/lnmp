Import-Module $PSScriptRoot/../../sdk/dockerhub/utils/Get-SHA.psm1

Function Test-Hash($path, $HashType = $null, $Hash = $null) {
  if (!$Hash) {
    return $true
  }

  if ($HashType -eq 'sha512') {
    if ($(GET-SHA512 $path) -eq $Hash) {
      return $true
    }
  }

  if ($HashType -eq 'sha384') {
    if ($(Get-SHA384 $path) -eq $Hash) {
      return $true
    }
  }

  if ($HashType -eq 'sha256') {
    if ($(Get-SHA256 $path) -eq $Hash) {
      return $true
    }
  }

  return $false
}

Export-ModuleMember -Function Test-Hash
