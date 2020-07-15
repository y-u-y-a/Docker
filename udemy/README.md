# 1. Linux基礎

## `touch` (ファイル作成)
## `rm` (ファイル削除)
## `pwd` (process working dir)
## `which` (コマンドの置かれている場所)
## `man` (コマンドのマニュアルを表示)
## `--help` (コマンドのヘルプ)
## `whoami` (ユーザー名取得)
## `cat /etc/passwd` (ユーザー覧取得)

## `echo >>` (ファイルに付け足し)
ファイル内容の末尾に追記

## `echo >` (ファイルを上書き)
ファイル内容を全て削除して上書き

## `cat` (ファイルの内容を表示)
concatenateの略
STDINの内容をSTDOUTに表示させる

## `ps` (プロセスを表示)
**PID**   -> Process ID\
**PTIME** -> 起動されてからの経過時間\
**PCMD**  -> プロセスが起動されたコマンド, ターミナル起動は/bin/bashなど\

## `find` (ファイルやフォルダを探す)
find [検索開始場所] -type [f or d] -name [探す名前]

## `grep` (ファイル上で文字検索)
grep "PID" [検索対象ファイルのパス] -n
-nで何行目かを表示する

## `|` (パイプ：最初のコマンドの出力を次のコマンドの入力に渡す)
例：フォルダ名を探し、その中のファイル名の中身を文字検索
find / -type d -name nginx | xargs grep -r html

## `watch` (コマンドを定期実行)
watch -t "docker ps"


## アタッチとデタッチ
tty -> バックグラウンドからフォアフラウンドへ\
(Tele Typewriter)\
detach -> フォアグラウンドからバックグラウンドへ\

フォアグラウンドのプロセス\
-> STDIN(入力)・STDOUT(出力)\


## `ctrl + r` (実行したコマンドを検索)





# 2. Docker基礎

## イメージ取得
```
$ docker pull nginx
```

## イメージの履歴を表示
```
$ docker history nginx
```

## 確認・表示コマンド
起動中コンテナのプロセス一覧
```
$ docker ps
```

コンテナ内のログ表示
```
$ docker logs [コンテナ名]
```

コンテナのメタデータ確認
```
$ docker inspect [コンテナ名]
```

## nginxコンテナを起動
nginxサーバーはデフォルトで80番ポートを公開
```
$ docker run --detach --name [コンテナ名] -p [ホスト側:コンテナ側] -d [イメージ名]
$ docker run --detach --name sandbox_nginx -p 8000:80 nginx
```

## nginxコンテナ停止
```
$ docker stop [コンテナ名 or コンテナID]
$ docker stop [sandbox_nginx]
```

## コンテナ内のシェルにアクセス
- bash (born again shell)\
- -it -> --interactive --tty
```
$ docker exec --interactive --tty [コンテナ名] bash
```

## 停止中のコンテナと無名のイメージを削除
```
$ docker system prune
```

## 起動中のコンテナ含め全て削除(注意)
--all, --quiet(IDのみを返す)
```
$ docker rm -vf $(docker ps -a -q)
```

## 全てのイメージ削除(注意)
```
$ docker rmi -f $(docker images -a -q)
```

## A. イメージからnginxコンテナ作成・起動まとめ
- --volumeで指定する際はディレクトリを指定する\
-> ディレクトリの中身がマウントされる\
- 環境変数は、コンテナ内でenvコマンドで確認できる
```
$ docker run \
    --detach \
    --name sandbox_nginx \
    -p 8000:80 \
    --volume $(pwd)/code:/home \
    --env TEST=hello_world \
    nginx
```

## B. 起動中コンテナからDockerイメージ作成
起動中のsandbox_nginxコンテナからhelloイメージ作成
```
$ docker commit [起動中コンテナ] [新イメージ]
$ docker commit sandbox_nginx hello
```

## C. helloイメージからhelloコンテナ起動
```
$ docker run \
    --detach \
    --name hello \
    -p 8000:80 \
    --volume $(pwd)/code:/usr/share/nginx/html \
    hello
```

## D. helloコンテナからレスポンス取得
```
$ curl localhost:8000
```



# 3. Dockerfile

## Dockerfileについて
設計書 -> クラス -> インスタンス
Dockerfile -> イメージ -> コンテナ
(build -> run)

- `COPY` (--volumeと同じ)
- `RUN` (シェルコマンドを実行)
- `WORKDIR` (コンテナ起動時のフォルダパス)
- `CMD` (コンテナ起動した後に実行するコマンド)

**１つ１つのコマンドでイメージレイヤーが追加されている(step実行)**
**イメージIDが追加されている**

## A. Dockerfileからイメージを作成
.(ドット)は、ビルトコンテキスト(Dockerfileの場所を指定)
```
$ docker build --tag [イメージ名？] .
```

## B. runコマンドでコンテナ作成・起動



# 4. Docker-Compose
- docker run とdocker composeの違いは、`同一ホスト上で複数コンテナを管理するかどうか？`
- なぜ使うか？
- １回のコマンドで複数コンテナを起動する
- yamlは、キーバリューの構成、インデントで階層を判断
- Docker runコマンドをyamlに変換できる
- docker-composeで起動したものは、downコマンドで一括停止できる
- logs --followでリアルタイムでログを確認できる
- --scale [サービス名]=[起動数]で同じコンテナを複数起動できる
- デフォルトでコンテナ同士は連絡が取れるようになっている
## デモ
```
$docker exec -it [コンテナ名] bash
$curl [入りたいコンテナ名]:[ポート番号]
```

# 5. ネットワーキング
- yamlの外部で起動されたコンテナには入れない
-> ネットワーキング(１番の山場)
- コンテナが起動するとき、裏ではネットワークネームスペースという個室が生成して、そこにコンテナが割り当てられている
- 本来はdocker-composeで区切られたコンテナ同士は会話できないが、デフォルトでBridgeネットワークを個々に作り、繋げている(**docker0**というVirtual Bridge Network, eth0がコンテナの中にあるネットワーク)

# 6. ストレージ
- コンテナは、儚い存在
- データは、コンテナ上ではなく、ホスト上に保存する
- ホスト上から、コンテナ上にマッピングして使う



# 7. SwarmとKubenetis
## どういう意味か？
- どちらも、群とかクラスターという意味がある
- `複数ホスト群`でコンテナを管理する
- `ホストを大量生産して、複数コンテナを複数ホストへ振り分ける`構造
## コンテナオーケストレーションとは？
->例えば、ホスト間でのロードバランシング、モニタリング、コンテナ同士のネットワーキングなどを管理する
## なぜ使うか？
- いくらコンテナがあっても唯一のホストが故障したら、コンテナも消滅してしまうから
- 複数ホストによるホスト間の管理・連携が難しいから
## Docker Swarm
- コンテナを起動
- スケールアップ
- ローリングアップデート
