. "$PSScriptRoot/common.ps1"

$NETWORK="lnmp_backend"
if ($null -eq $(docker network ls -f name="lnmp_backend" -q)){
  $NETWORK="bridge"
}

docker run -it --rm `
    --mount type=bind,src=$(wslpath $PWD),target=/app `
    --mount type=bind,src=$(wslpath ${PSScriptRoot}/../config/npm/.npmrc),target=/usr/local/etc/npmrc `
    --mount type=volume,src=lnmp_npm-cache-data,target=/tmp/node/.npm `
    --mount type=volume,src=lnmp_npm-global-data,target=/tmp/node/npm `
    --env-file ${PSScriptRoot}/../config/npm/.env `
    --workdir /app `
    --entrypoint npm `
    --network ${NETWORK} `
    ${LNMP_NODE_IMAGE} `
    $args
