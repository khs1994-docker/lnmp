. $PSScriptRoot\..\request.ps1
. $PSScriptRoot\..\utils\trim_v.ps1

Function getLatestTag($repo,$page=0,$index=0){
  $url="https://api.github.com/repos/$repo/tags"

  if($page){
    $lastPage=(request HEAD https://api.github.com/repos/$repo/tags).RelationLink.last
    $repoId=$lastPage.split('/')[4]
    $url="https://api.github.com/repositories/$repoId/tags?page=$page"
  }

  $tags=(request GET $url).content

  $tags_obj=ConvertFrom-Json -InputObject $tags

  return trim_v $tags_obj[$index].name
}
