. $PSScriptRoot\..\request.ps1

Function getLatestRelease($repo){
  # $lastPage=(request HEAD https://api.github.com/repos/$githubRepo/releases).RelationLink.last
  $releases=(request GET https://api.github.com/repos/$repo/releases).content
  $releases_obj=ConvertFrom-Json -InputObject $releases

  return $latestRelease=$releases_obj[0].tag_name
}
