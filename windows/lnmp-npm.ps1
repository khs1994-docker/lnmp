. "$PSScriptRoot/common.ps1"

docker run -it --rm `
    --mount type=bind,src=$PWD,target=/app `
    --mount type=bind,src=${PSScriptRoot}/../config/npm/.npmrc,target=/usr/local/etc/npmrc `
    --mount type=volume,src=lnmp_npm_cache-data,target=/tmp/node/.npm `
    --mount type=volume,src=lnmp_npm_global-data,target=/tmp/node/npm `
    --env-file ${PSScriptRoot}/../config/npm/.env `
    --workdir /app `
    --entrypoint npm `
    ${LNMP_NODE_IMAGE} `
    $args
