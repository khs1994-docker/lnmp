. "$PSScriptRoot/common.ps1"

$NETWORK="lnmp_backend"
if ($null -eq $(docker network ls -f name="lnmp_backend" -q)){
  $NETWORK="bridge"
}

$LNMP_LIBRARY_NS=GET-ENV LNMP_LIBRARY_NS "$PSScriptRoot/../.env" library
$LNMP_NODE_IMAGE=GET-ENV LNMP_NODE_IMAGE "$PSScriptRoot/../.env" node:alpine

docker run -it --rm `
  -v ${PSScriptRoot}/../config/yarn/.yarnrc:/usr/local/share/.yarnrc `
  -v lnmp_yarn_cache-data:/tmp/node/.yarn `
  -v lnmp_yarn_global-data:/tmp/node/yarn `
  --network none `
  ${LNMP_LIBRARY_NS}/bash `
  bash -c `
  "set -x;chown -R ${LNMP_USER} /tmp/node/.yarn; `
   chown -R ${LNMP_USER} /tmp/node/yarn; `
  "

docker run -it --rm `
    -v ${PWD}:/app `
    -v ${PSScriptRoot}/../config/yarn/.yarnrc:/usr/local/share/.yarnrc `
    -v lnmp_yarn_cache-data:/tmp/node/.yarn `
    -v lnmp_yarn_global-data:/tmp/node/yarn `
    --env-file ${PSScriptRoot}/../config/yarn/.env `
    --network ${NETWORK} `
    --workdir /app `
    --entrypoint yarn `
    --user ${LNMP_USER} `
    $(Write-Output $LNMP_NODE_IMAGE) `
    $args

    # --registry https://registry.npmmirror.com `
    # --cache-folder /tmp/node/.yarn `
    # --global-folder /tmp/node/yarn `
