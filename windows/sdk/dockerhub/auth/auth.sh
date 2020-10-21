getTokenServerAndService(){
  registry=${1:-registry.hub.docker.com}

  if [ $registry = 'docker.io' ];then
    registry=registry.hub.docker.com
  fi

  WWW_Authenticate=`curl -L https://$registry/v2/ \
-X GET -I -A "Docker-Client/19.03.5 (Linux)" | grep -i 'www\-authenticate' `

if [ $? -eq 0 ];then
  realm=`echo $WWW_Authenticate | awk -F"," '{print $1}'`
  service=`echo $WWW_Authenticate | cut -d "," -f 2`

  realmKey=`echo $realm | cut -d " " -f 3 | cut -d "=" -f 1`
  if [ "$realmKey" = 'realm' ];then
    tokenServer=`echo $realm | cut -d " " -f 3 | cut -d "=" -f 2 | sed "s#'##g" | sed 's#"##g'`
  fi

  serviceKey=`echo $service | cut -d "=" -f 1`
  if [ "$serviceKey" = 'service' ];then
    tokenService=`echo "$service" | cut -d "=" -f 2 | sed 's#"##g' | sed 's#\\r##g'`
  fi
fi
}

getToken(){
  command -v curl > /dev/null || echo "==> Please install curl" > /dev/stderr
  command -v curl > /dev/null || exit 1
  command -v jq > /dev/null || echo "==> Please install jq" > /dev/stderr
  command -v jq > /dev/null || exit 1

  image=$1
  action=${2:-pull}
  registry=${3:-registry.hub.docker.com}
  cache=${4:-0}

  getTokenServerAndService $registry

  if [ -z "$tokenServer" ];then
    echo "==> tokenServer and tokenService not found, this registry maybe not need token" > /dev/stderr

    token='token'

    return
  fi

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

  curl -fsSL -H "Authorization:basic $basic" \
"${tokenServer}?service=${tokenService}&scope=repository:${image}:${action}" \
-o $token_file \
-A "Docker-Client/19.03.5 (Linux)"
else
  curl -fsSL \
"${tokenServer}?service=${tokenService}&scope=repository:${image}:${action}" \
-o $token_file \
-A "Docker-Client/19.03.5 (Linux)"
fi

token=`cat $token_file | jq '.token' | sed 's#"##g' `

# echo "$token" > /dev/stderr
}
