
プロジェクト構築
================================================

## 1. Laravel内に.envを作成・編集
    $ cp ./code/.env.example ./code/.env

```
APP_NAME=laravelApp
・・・
DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=laravelApp
DB_USERNAME=root
DB_PASSWORD=root
```
* DB_HOST
→ docker-compose.yamlのサービス名を指定
* DB_PORT
→ コンテナ内で解放しているポートを指定
→ mysql自体をDockerネットワーク内に構築しているから


## 2. コンテナを作成・起動
    $ docker-compose up -d


## 3. シェルスクリプト(settings.sh)を実行
    $ chmod 755 docker/settings.sh
    $ docker/settings.sh

* composer install
→ /vendorが生成し、ライブラリがインストールされる
* php artisan key:generate
→ .envにAPP_KEYが生成される
* npm install
→ /node_modulesが生成し、package.jsonを参考にライブラリがインストールされる

## 4. ブラウザで起動しているか確認
localhost:8000にアクセス


その他Tips
================================================

## エラーが出た場合
    $ docker logs [コンテナID or コンテナ名]

## ファイル名を指定して実行したい場合
    $ docker-compose -f ./[ファイル名].yaml up -d

## 基本的にコマンドはコンテナ内で実行
→ migrateなど


生成するもの
================================================

## 1. コンテナ各群(container)
## 2. コンテナ同士を結びつけるネットワーク(network)
## 3. MySQLデータボリューム(volume)
→ コンテナ削除しても永続的に残る
→ 削除したい場合は個別にする必要がある
