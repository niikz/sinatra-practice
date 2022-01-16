## MEMO APP
"MEMO APP"はブラウザ上で使えます。
Sinatraで作成された簡易的なメモアプリです。

## DEMO
このアプリでは、メモを作成・編集・削除することができます。
作成日時の新しいメモが上に追加されていきます。

<img src="https://user-images.githubusercontent.com/60736158/127842359-cf35bb47-a591-40f8-898f-3b62f0509bbf.gif" width="360">

## Requirement
- Ruby 2.7.3
    - Ruby 3.0 以降の場合、WEBrickが必要です
- Sinatra 2.1.0
- psql (PostgreSQL) 13.3
- pg (1.2.3)

## Installation
`memo_app`というデータベースを用意してください。
リポジトリをクローンし、アプリを実行します。

```
% https://github.com/niikz/sinatra-practice.git
% bundle install
% bundle exec ruby app.rb
```

アプリを実行後、下記へアクセスしてください。
```
http://localhost:4567/notes
```

## Author
@niikz
