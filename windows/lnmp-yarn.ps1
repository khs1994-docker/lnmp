docker run -it --rm `
    --mount type=bind,src=$PWD,target=/app `
    --mount type=volume,src=lnmp_yarn-data,target=/tmp/node/.yarn `
    --workdir /app `
    --entrypoint yarn `
    node:alpine `
    --registry https://registry.npm.taobao.org --cache-folder /tmp/node/.yarn $args
