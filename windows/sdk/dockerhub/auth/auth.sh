getToken(){
  command -v curl > /dev/null || echo "==> Please install curl" > /dev/stderr
  command -v curl > /dev/null || exit 1
  command -v jq > /dev/null || echo "==> Please install jq" > /dev/stderr
  command -v jq > /dev/null || exit 1

  image=$1
  action=${2:-pull}
  tokenSever=${3:-"https://auth.docker.io/token"}
  tokenService=${4:-registry.docker.io}
  cache=${5:-0}

  mkdir -p `getCachePath token`

  token_file=`getCachePath \
             "token/$(echo $image | sed 's#/#@#g' )@${action}@$(echo $tokenService | sed 's#:#-#g')" `

  echo "==> Token file is $token_file" > /dev/stderr

  if [ $cache -eq 1 -a -f $token_file ];then
    token=`cat $token_file | jq '.token' | sed 's#"##g' `

    # echo "$token" > /dev/stderr

    return
  fi

if [ -z "${DOCKER_USERNAME}" -o -z "${DOCKER_PASSWORD}" ];then
  echo "==> ENV var DOCKER_USERNAME DOCKER_PASSWORD not set" > /dev/stderr
fi

if [ -n "${DOCKER_USERNAME}" -a -n "${DOCKER_PASSWORD}" ];then
  basic=`echo -n "${DOCKER_USERNAME:-usernamekhs1994666}:${DOCKER_PASSWORD:-passwordkhs1994666}" | base64`

  curl -L -H "Authorization:basic $basic" \
"${tokenSever}?service=${tokenService}&scope=repository:${image}:${action}" \
-o $token_file \
-A "Docker-Client/19.03.5 (Linux)"
else
  curl -L \
"${tokenSever}?service=${tokenService}&scope=repository:${image}:${action}" \
-o $token_file \
-A "Docker-Client/19.03.5 (Linux)"
fi

token=`cat $token_file | jq '.token' | sed 's#"##g' `

# echo "$token" > /dev/stderr
}
