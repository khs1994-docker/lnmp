. "$PSScriptRoot/common.ps1"

$NETWORK="lnmp_backend"
if ($null -eq $(docker network ls -f name="lnmp_backend" -q)){
  $NETWORK="bridge"
}

docker run -it --rm `
  --mount type=bind,src=${PSScriptRoot}/../config/yarn/.yarnrc,target=/usr/local/share/.yarnrc `
  --mount type=volume,src=lnmp_yarn_cache-data,target=/tmp/node/.yarn `
  --mount type=volume,src=lnmp_yarn_global-data,target=/tmp/node/yarn `
  --network none `
  bash `
  bash -c `
  "set -x;chown -R ${LNMP_USER} /tmp/node/.yarn; `
   chown -R ${LNMP_USER} /tmp/node/yarn; `
  "

docker run -it --rm `
    --mount type=bind,src=$($PWD.ProviderPath),target=/app `
    --mount type=bind,src=$PSScriptRoot/../config/yarn/.yarnrc,target=/usr/local/share/.yarnrc `
    --mount type=volume,src=lnmp_yarn_cache-data,target=/tmp/node/.yarn `
    --mount type=volume,src=lnmp_yarn_global-data,target=/tmp/node/yarn `
    --env-file ${PSScriptRoot}/../config/yarn/.env `
    --network ${NETWORK} `
    --workdir /app `
    --entrypoint yarn `
    --user ${LNMP_USER} `
    ${LNMP_NODE_IMAGE} `
    $args

    # --registry https://registry.npmmirror.com `
    # --cache-folder /tmp/node/.yarn `
    # --global-folder /tmp/node/yarn `
