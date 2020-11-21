Function _getHttpCode($url) {
  if (!$url) {
    return "404"
  }

  try {
    # (Invoke-WebRequest -Method HEAD $url).StatusCode | out-null
    $StatusCode = ((curl -X GET -sI $url | select-string HTTP)[0] | select-string 200)
    if (!($StatusCode)) {
      throw 'error'
    }
  }
  catch {
    return '404'
  }

  return '200'
}
