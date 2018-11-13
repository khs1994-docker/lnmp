docker run -it --rm `
    --mount type=bind,src=$PWD,target=/app `
    --mount type=volume,src=lnmp_npm-data,target=/tmp/node/.npm `
    --workdir /app `
    --entrypoint npx `
    node:alpine `
    --registry https://registry.npm.taobao.org --cache /tmp/node/.npm $args
