getToken(){
  command -v curl > /dev/null || exit 1
  command -v jq > /dev/null || exit 1

  image=$1
  action=${2:-pull}
  tokenSever=${3:-"https://auth.docker.io/token"}
  tokenService=${4:-registry.docker.io}
  cache=${5:-0}

  token_file=`getCachePath \
             ".token@$(echo $image | sed 's#/#@#g' )@${action}@$(echo $tokenService | sed 's#:#-#g')" `

  echo "==> Token file is $token_file" > /dev/stderr

  if [ $cache -eq 1 -a -f $token_file ];then
    token=`cat $token_file | jq '.token' | sed 's#"##g' `

    # echo "$token" > /dev/stderr

    return
  fi

if [ -z "${DOCKER_USERNAME}" -o -z "${DOCKER_PASSWORD}" ];then
  echo "==> ENV var DOCKER_USERNAME DOCKER_PASSWORD not set" > /dev/stderr
fi

basic=`echo -n "${DOCKER_USERNAME:-usernamekhs1994666}:${DOCKER_PASSWORD:-passwordkhs1994666}" | base64`

curl -H "Authorization:basic $basic" \
"${tokenSever}?service=${tokenService}&scope=repository:${image}:${action}" \
-o $token_file \
-A "Docker-Client/19.03.5 (Linux)"

token=`cat $token_file | jq '.token' | sed 's#"##g' `

# echo "$token" > /dev/stderr
}
