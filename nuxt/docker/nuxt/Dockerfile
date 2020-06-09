FROM node:12.1.0-alpine

RUN mkdir /code

WORKDIR /code

RUN npm install -g vue-cli

# 外部に公開するポートを指定(run時の-pオプション)
EXPOSE 3000
