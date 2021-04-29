# 報告書共有ステーション
https://warm-tor-13687.herokuapp.com/
<img src="./public/images/TOP.png" alt="TOP画面">

## 制作の背景
今まで働いてきた中で、報告書を作成し上司に提出機会が多々ありました。<br>
その際、手間がかかる作業等の以下の問題点があり、報告書の運用管理をする際の問題点に着目して、<br>
それらを解決できるアプリケーションを作成しました。<br>

【問題点】<br>
- 報告書を紙媒体で保管<br>
⇒類似案件を探す際に大変、保管場所のスペースが取られる<br>
- チーム内にて、報告書の担当数に偏りがある<br>
⇒特定の人に負担が多くなる<br>
- たくさんの人から、作成中の報告書についてメールにて意見集中<br>
⇒何通ものメールを見る必要がある＆関連メールを探すのが大変<br>
- 作成した報告書に上司の押印が必要(中には直接、押印をもらいに行く必要あり)<br>
- 報告書の提出〆切を忘れがち<br>


## 概要
社内、工場にてトラブル(※1)が発生した際、作成される報告書の記録や進捗状況の確認、また報告書の内容にコメントを残すことができるツール						
- チームを作成し、そのチーム内でトラブルの報告書の運用管理ができる(運用管理とは、報告書の作成や修正、承認、クローズ、コメント等)							
- チーム内には、必ず責任者：1名、担当者：1名(最低)、その他の関係者らを登録でき、また複数のトラブルの報告書を登録できる							
- 報告書内にはトラブル発生時の状況や応急対応の内容、暫定対策案、恒久対策案を記録することができる
- 報告書の提出期限が迫ると関係者(責任者、担当者も含む)に提出を促すお知らせメールが事前登録済みのメールアドレスに通知される
- 報告書を新規作成、内容更新をすると関係者(責任者、担当者も含む)にその旨のお知らせメールが事前登録済みのメールアドレスに通知される
- トラブル毎の担当者がわかる
- 報告書内容の各対策案の進捗状況が確認できる
- 各トラブルにおける報告書の進捗状況が把握できる
- 責任者の承認がないと、報告書をクローズすることができない(責任者の承認が得られるまで担当者は報告書を書き直す)
(※1)製品品質に関わる事故、環境破壊に関わる事故、火災事故、労災事故等				


## できること詳細
#### 報告書一覧(作成中)ページ
https://docs.google.com/spreadsheets/d/1bmyBLmHnn4NFDbJqat0Ty4VN9wqgdejzqYHz7MBw4fU/edit#gid=1823805619
#### 報告書一覧(アーカイブ)ページ
https://docs.google.com/spreadsheets/d/1bmyBLmHnn4NFDbJqat0Ty4VN9wqgdejzqYHz7MBw4fU/edit#gid=1910614996
#### チーム詳細ページ
https://docs.google.com/spreadsheets/d/1bmyBLmHnn4NFDbJqat0Ty4VN9wqgdejzqYHz7MBw4fU/edit#gid=172898706
#### 報告書作成ページ
https://docs.google.com/spreadsheets/d/1bmyBLmHnn4NFDbJqat0Ty4VN9wqgdejzqYHz7MBw4fU/edit#gid=823170295

## バージョン情報
- Ruby 2.6.5
- Rails 5.2.4.5

## 機能一覧・カタログ設計
https://docs.google.com/spreadsheets/d/1bmyBLmHnn4NFDbJqat0Ty4VN9wqgdejzqYHz7MBw4fU/edit#gid=0
## テーブル定義
https://docs.google.com/spreadsheets/d/1bmyBLmHnn4NFDbJqat0Ty4VN9wqgdejzqYHz7MBw4fU/edit#gid=51706545
## テーブル定義詳細
https://docs.google.com/spreadsheets/d/1bmyBLmHnn4NFDbJqat0Ty4VN9wqgdejzqYHz7MBw4fU/edit#gid=251104556
## ER図
https://docs.google.com/spreadsheets/d/1bmyBLmHnn4NFDbJqat0Ty4VN9wqgdejzqYHz7MBw4fU/edit#gid=1951023534
## 画面遷移図
https://docs.google.com/spreadsheets/d/1bmyBLmHnn4NFDbJqat0Ty4VN9wqgdejzqYHz7MBw4fU/edit#gid=907808007
## ワイヤーフレーム
https://cacoo.com/diagrams/PfKXwpeo68GR5ckw#16930

## 使用Gem
- carrierwave
- mini_magick
- devise
- ransack
- kaminari
- devise-i18n
- enum_help
- bcrypt
- faker
