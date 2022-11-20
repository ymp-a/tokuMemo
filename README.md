# トクメモ TokuMemo〜あなたのトクした瞬間を保管します〜

## 1. 概要
トクメモは買い物のトクした気持ちを保存するアプリです。<br>登録した最安値などの情報をカテゴリ、店舗毎にすぐチェックできます。<br>登録した商品情報をカテゴリ、ショップ２つのTagで管理できます。
## 2. ダウンロードリンク
リリース待ち
## 3. 実行画面
- 商品登録

https://user-images.githubusercontent.com/68992872/201657023-86fde2d9-5a0a-4363-a764-f97309ec3ba6.mp4

- Tab組合せによる一覧表反映

https://user-images.githubusercontent.com/68992872/201657367-59244dc3-1a9e-40f7-bfd1-7113a6f5eaea.mp4

## 4. アプリの機能
- 商品価格、単価を一覧表示
- シンプルに税込購入金額を入力
- カテゴリ・ショップの組合せで一覧表示を切り替えます

## 5. アプリの設計について
|ファイル名|解説・概要|
|--|--|
|TokuMemoListView|ホームView、カテゴリ、ショップTabの条件で商品一覧をList表示する|
|AddItemView|新規商品登録View|
|EditItemView|商品情報変更View|
|CategoryListView|カテゴリを選択、追加、編集、削除をを行うView|
|ShopListView|ショップを選択、追加、編集、削除を行うView|
|CategoryShopTagView|カテゴリ、ショップのTabボタン、CategoryListView,ShopListView表示フラグ管理機能があるView|
|EditViewModel|カテゴリ、ショップ名の編集を処理します|
|DeleteViewModel|商品、カテゴリ、ショップの削除を処理します|
|||

```mermaid
graph LR;
  1(TokuMemoListView)--追加-->AddItemView--更新-->CoreData;
  1--変更-->EditItemView--更新-->CoreData;
  1--削除-->DeleteViewModel--更新-->CoreData;
  1--カテゴリTab-->CategryListView--選択でView更新-->1
  1--ショップTab-->ShopListView--選択でView更新-->1
  CoreData--Viewを更新-->1
```


```mermaid
graph LR;
  1(TokuMemoListView)--依存-->2(CategryListView)--カテゴリ選択-->1
  1--ショップTab選択-->3(ShopListView)--ショップ選択-->1
  
  4(AddItemView)--カテゴリTabタップ-->2'(CategryListView)--カテゴリ選択-->4
  4--ショップTab選択-->3'(ShopListView)--ショップ選択-->4
```

```mermaid
graph LR;
  2(CategryListView)--追加-->追加アラート--入力チェック&更新-->CoreData
  2--編集-->編集アラート--入力チェック-->EditItemView--更新-->CoreData
  2--削除-->DeleteViewModel--更新-->CoreData
  CoreData--Viewを更新-->2
```

  

## 6. こだわり
- カテゴリ、ショップが変更された時にパターンに応じて条件を更新します
https://github.com/ymp-a/tokuMemo/blob/a5b720fc36e4404f28fff5000942338699ec0b5a/tokuMemo/View/TokuMemoListView.swift#L105-L110
https://github.com/ymp-a/tokuMemo/blob/a5b720fc36e4404f28fff5000942338699ec0b5a/tokuMemo/View/TokuMemoListView.swift#L148-L168

- TabViewの分割
  - どこまで分割するか悩みました
https://github.com/ymp-a/tokuMemo/blob/a5b720fc36e4404f28fff5000942338699ec0b5a/tokuMemo/View/CategoryShopTagView.swift#L32-L33
https://github.com/ymp-a/tokuMemo/blob/a5b720fc36e4404f28fff5000942338699ec0b5a/tokuMemo/View/CategoryShopTagView.swift#L58-L92

## 7. 開発環境
- Xcode 14.0.1
- macOS Ventura 13.0
- iPhone simulater 14.0.1
- iPhone実機 iOS16.0
  SwiftUIで開発されているためiOS16以降が必要です
  
## 8. 操作説明
[note トクメモアプリの使い方](https://note.com/ymp_a/n/n40460a324017)
## 9. 作成者
https://twitter.com/YMPa_FXSB103
## 10. ご意見
([問い合わせ](https://docs.google.com/forms/d/e/1FAIpQLSechH7A7sbCKsNdlG7AUxLwEffGEWgnq4CVrifFcn8_l53q1w/viewform?usp=sf_link)) ([プライバシーポリシー](PrivacyPolicy.md))
