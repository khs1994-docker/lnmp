FROM node:8-alpine

RUN echo "registry=https://registry.npm.taobao.org" > ~/.npmrc

WORKDIR /data/lnmp

COPY package.json package.json

RUN npm install

CMD node run start
