Function _getHttpCode($url) {
  if (!$url) {
    return "404"
  }

  try {
    (Invoke-WebRequest -Method HEAD $url).StatusCode | out-null
  }
  catch {
    return '404'
  }

  return '200'
}
