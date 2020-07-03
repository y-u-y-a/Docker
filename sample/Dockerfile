# 元になるイメージを指定
# Dockerfileはイメージをカスタマイズするために使用する
FROM docker/whalesay:latest
# RUNはイメージビルド時に実行するコマンド
# whalesayはubuntu OSがベースとなっているのでapt-getコマンドを使用
RUN apt-get -y update && apt-get install -y fortunes
# CMDはコンテナが作成された後に実行される
CMD /usr/games/fortune | cowsay
