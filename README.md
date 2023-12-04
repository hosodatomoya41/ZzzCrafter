# ZzzCrafter
<img src="app/assets/images/ogp.png">

## サービス概要
ZzzCraferは睡眠に役立つルーティーンを選んで実践していただき、睡眠の質を向上させることを目的としたアプリです。<br>
どのルーティーンを実践したら朝の調子が良くなるかを可視化し、自分に合ったルーティーンを探すことができます。

## サービスのURL
https://zzzcrafter.fly.dev

## 主な機能

| 睡眠の記録の確認 | ルーティーンの登録 | おすすめのルーティーンの確認 |
|:-------------------:|:-----------------------------:|:-----------------:|
| ![line_sleep_record](https://github.com/hosodatomoya41/ZzzCrafter/assets/123244117/1955b002-96e1-4c78-a5ec-338c20892993) | ![routine_index](https://github.com/hosodatomoya41/ZzzCrafter/assets/123244117/f9aa0dec-45bb-4817-ba46-958beef971df) | ![line_recommend_routine](https://github.com/hosodatomoya41/ZzzCrafter/assets/123244117/3d5be285-cffb-446c-9153-a14cb6b68e75) |
| 睡眠の記録を確認できます。<br>起床、就寝時間の設定も行えます。 | ルーティーン一覧を確認し、<br>登録することができます。 | 今まで実践したルーティーンの中から、最適なものを確認できます。 |


## 使用技術

| カテゴリ         | 技術               |
|----------------|-------------------|
| バックエンド     | Ruby on Rails 7.0.6 |
|              | Ruby 3.0.2        |
| フロントエンド   | Hotwire       |
|              | TailwindCSS    |
| データベース    | PostgreSQL        |
| インフラ        | Fly.io            |
| API            | LINE Messaging API|


### ER図
<img src="app/assets/images/er_diagram.png">
