# Momoka - ももか -

## 概要

Twitterアカウント データをリスト等から取得し、データを取得します


## 準備

sqlフォルダを参照

```
mysql database_name < twitter_follwer_status.sql
mysql database_name < twitter_follwer_status_histories.sql
```


```
bundle install
```

## ツイッターのデータを収集

```
bundle exe ruby momoka.rb database_name list.txt
```


例

```
bundle exe ruby momoka.rb circle_twitter private/tw_list_all.txt
```

