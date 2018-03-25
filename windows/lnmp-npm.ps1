#!/bin/bash

docker run -it --rm `
    --mount type=bind,src=$pwd,target=/app `
    --workdir /app `
    node:alpine `
    $args
