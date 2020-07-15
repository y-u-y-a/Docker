FROM nginx

# --volumeと同じ役割
COPY index.html index.html

# &&は前のコマンドが成功したら次を実行
# curlコマンドをインストール(y/nが聞かれるところを-yのyesで通過)
RUN apt update && apt install -y curl

# コンテナが起動するときのフォルダパスを指定
WORKDIR /usr/share/nginx/html

# コンテナが起動した後に最初に実行するコマンドを指定
CMD [ "nginx", "-g", "daemon", "off" ]
