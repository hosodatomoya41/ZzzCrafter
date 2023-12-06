# ZzzCrafter
<img src="app/assets/images/ogp.png">

## サービス概要
ZzzCraferは睡眠に役立つルーティーンを選んで実践していただき、睡眠の質を向上させることを目的としたアプリです。<br>
どのルーティーンを実践したら朝の調子が良くなるかを可視化し、自分に合ったルーティーンを探すことができます。

## サービスのURL
https://zzzcrafter.com

## 主な機能

**1.睡眠時間の設定**
起床時間と就寝時間を設定していただくと、適切なタイミングでLINE通知が届くようになり、睡眠の記録も確認できるようになります。

**2.ルーティーンの登録**
おすすめの実践時間別に様々なルーティーンをご紹介しております。
気になったルーティーンを登録してみてください。

**3.翌朝に調子を記録**
翌朝の設定した起床時間にLINE通知が届くので、起きたときの調子を3段階評価で記録できます。
実践しやすく、効果を感じるルーティーンが見つかるまで色々試してみてください！

| 1.睡眠時間の設定 | 2.ルーティーンの登録 | 3.翌朝に調子を記録 |
|:--|:--|:--|
| ![sleep_record.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3185454/bf658c98-e4d2-405b-a2c8-bf550ca0e5e1.gif) | ![routine_index](https://github.com/hosodatomoya41/ZzzCrafter/assets/123244117/a5eaf8af-2498-499c-8d80-4cfe16fcab68) | ![morning_condition](https://github.com/hosodatomoya41/ZzzCrafter/assets/123244117/be344269-65bf-4cab-829b-d993320da3cc) |
| 起床時間と就寝時間を設定します。 | 実践しやすいものを選び<br>登録することができます。 | 設定した起床時間に<br>LINE通知が届きます。 |

### ▼LINEでも利用可能です<br>
| 睡眠の記録の確認 | ルーティーンの登録 | おすすめのルーティーンの確認 |
|:-------------------:|:-----------------------------:|:-----------------:|
| ![line_sleep_record](https://github.com/hosodatomoya41/ZzzCrafter/assets/123244117/1955b002-96e1-4c78-a5ec-338c20892993) | ![routine_index](https://github.com/hosodatomoya41/ZzzCrafter/assets/123244117/f9aa0dec-45bb-4817-ba46-958beef971df) | ![line_recommend_routine](https://github.com/hosodatomoya41/ZzzCrafter/assets/123244117/3d5be285-cffb-446c-9153-a14cb6b68e75) |
| 睡眠の記録を確認できます。<br>起床、就寝時間の設定も行えます。 | ルーティーン一覧を確認し、<br>登録することができます。 | 実践したルーティーンの中から、<br>最適なものを確認できます。 |


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
![er_diagram](https://github.com/hosodatomoya41/ZzzCrafter/assets/123244117/5498f8a9-fb24-4db1-b4bf-6452292e812b)



