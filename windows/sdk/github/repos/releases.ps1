. $PSScriptRoot\..\request.ps1
. $PSScriptRoot\..\utils\trim_v.ps1

Function getLatestRelease($repo){
  # $lastPage=(request HEAD https://api.github.com/repos/$githubRepo/releases).RelationLink.last
  $releases=(request GET https://api.github.com/repos/$repo/releases).content
  $releases_obj=ConvertFrom-Json -InputObject $releases

  $preRelease=$null
  $stableRelease=$null

  if(!$releases_obj){
    Write-Warning "get latest version from git tag, maybe not correct or outdated"
    . $PSScriptRoot\repos.ps1

    $stableRelease = getLatestTag $repo

    return $stableRelease,$preRelease
  }

  for($i=0;$i -le 28; $i++){
    if(!$releases_obj[$i]){
      break;
    }
    $release = $releases_obj[$i];
    $isPrerelease = $release.prerelease
    if($isPrerelease -and !$preRelease){
      $preRelease = trim_v $release.tag_name
    }

    if(!$isPrerelease -and !$stableRelease){
      $stableRelease = trim_v $release.tag_name
    }

    if($preRelease -and $stableRelease){
      return $stableRelease,$preRelease
    }
  }

  return $stableRelease,$preRelease
}
