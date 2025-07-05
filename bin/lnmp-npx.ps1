. "$PSScriptRoot/common.ps1"

$NETWORK="lnmp_backend"
if ($null -eq $(docker network ls -f name="lnmp_backend" -q)){
  $NETWORK="bridge"
}

$LNMP_LIBRARY_NS=GET-ENV LNMP_LIBRARY_NS "$PSScriptRoot/../.env" library
$LNMP_NODE_IMAGE=GET-ENV LNMP_NODE_IMAGE "$PSScriptRoot/../.env" node:alpine

docker run -i ${tty} --rm `
  -v lnmp_npm-cache-data:/tmp/node/.npm `
  -v lnmp_npm-global-data:/tmp/node/npm `
  --network none `
  ${LNMP_LIBRARY_NS}/bash `
  bash -c `
  "set -x;chown -R ${LNMP_USER} /tmp/node/.npm; `
   chown -R ${LNMP_USER} /tmp/node/npm; `
  "

docker run -it --rm `
    -v ${PWD}:/app `
    -v ${PSScriptRoot}/../config/npm/.npmrc:/usr/local/etc/npmrc `
    -v lnmp_npm-cache-data:/tmp/node/.npm `
    -v lnmp_npm-global-data:/tmp/node/npm `
    --env-file ${PSScriptRoot}/../config/npm/.env `
    --workdir /app `
    --entrypoint npx `
    --user ${LNMP_USER} `
    --network ${NETWORK} `
    $(Write-Output $LNMP_NODE_IMAGE) `
    $args
