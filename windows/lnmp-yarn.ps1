. "$PSScriptRoot/common.ps1"

docker run -it --rm `
    --mount type=bind,src=$PWD,target=/app `
    --mount type=bind,src=${PSScriptRoot}/../config/yarn/.yarnrc,target=/usr/local/share/.yarnrc `
    --mount type=volume,src=lnmp_yarn_cache-data,target=/tmp/node/.yarn `
    --mount type=volume,src=lnmp_yarn_global-data,target=/tmp/node/yarn `
    --env-file ${PSScriptRoot}/../config/yarn/.env `
    --workdir /app `
    --entrypoint yarn `
    ${LNMP_NODE_IMAGE} `
    $args

    # --registry https://registry.npm.taobao.org `
    # --cache-folder /tmp/node/.yarn `
    # --global-folder /tmp/node/yarn `

    # --mount type=bind,src=${PSScriptRoot}/../config/yarn/.yarnrc,target=/usr/local/share/.yarnrc `
