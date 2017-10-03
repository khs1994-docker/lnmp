FROM node:8-alpine

RUN apk add --no-cache git tzdata openssh \
      && echo "registry=https://registry.npm.taobao.org" > ~/.npmrc

WORKDIR /data/lnmp/ci

COPY package.json package.json

RUN npm install

CMD npm run update
