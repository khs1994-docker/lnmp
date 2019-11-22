Function trim_v($release_name){
  if($release_name.indexOf('v') -eq 0){
    return $release_name.subString(1)
  }

  return $release_name
}
