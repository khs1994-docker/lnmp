Function _getHttpCode($url){
  if(!$url){
    return "404"
  }
  return (curl.exe -sI $url).split(" ")[1].toString()
}
