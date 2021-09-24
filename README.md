# Momoka - ももか -

## 概要

Twitterアカウント データをリスト等から取得し、データを取得します


## テーブル準備 DDL実行

sqlフォルダを参照

```
mysql database_name < twitter_follwer_status.sql
mysql database_name < twitter_follwer_status_histories.sql
```


```
bundle install
```

## DB接続は環境変数で設定

```
export MOMOKA_DB_HOST=
export MOMOKA_DB_USER=
export MOMOKA_DB_PASSWORD=
```


## ツイッターのデータを収集

```
bundle exe ruby momoka.rb database_name list.txt
```


例

```
bundle exe ruby momoka.rb anime_database private/tw_list_all.txt
```


## Docker 実行

```
docker build -t momoka .
```

```
docker run --rm -e MOMOKA_DB_HOST="docker.for.mac.localhost" -e MOMOKA_DB_USER="root" -e MOMOKA_DB_PASSWORD="" -v $(pwd)/private:/usr/src/app/private -i momoka ruby momoka1.rb anime_admin_development ./private/list32.txt
```