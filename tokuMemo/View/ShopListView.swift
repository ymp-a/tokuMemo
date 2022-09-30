//
//  ShopListView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/07/13.
//

import SwiftUI
import CoreData

// 初期データ登録用
func registSampleShopData(context: NSManagedObjectContext) {

    /// Shopテーブル初期値
    let shopList = [
        ["すべて", "", "2022/08/09" ],
        ["サンプル店", "", "2022/08/10"]
    ]

    /// Shopテーブル全消去
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    fetchRequest.entity = Shop.entity()
    let shops = try? context.fetch(fetchRequest) as? [Shop]
    for shop in shops! {
        context.delete(shop)
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/M/d"

    /// Shopテーブル登録
    for shop in shopList {
        let newShop = Shop(context: context)
        newShop.name = shop[0]         // カテゴリー名
        newShop.memo = shop[1]        // メモ
        newShop.timestamp = dateFormatter.date(from: shop[2])! // 追加日
    }

    /// コミット
    try? context.save()
}

struct ShopListView: View {
    // モーダル終了処理
    @Environment(\.dismiss) var dismiss
    /// 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // ショップ名テキスト部分
    @Binding var shopName: String

    @State private var inputText = ""
    // ショップ追加アラート表示
    @State private var presentAlert = false
    // ショップ編集アラート表示
    @State private var presentEditAlert = false
    // モディファイアView表示
    @State var isShowAction = false
    // タップした行の情報を渡す
    @State private var editShop: Shop?
    /// データ取得処理
    @FetchRequest(
        entity: Shop.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Shop.timestamp, ascending: true)],
        predicate: nil
    ) private var shops: FetchedResults<Shop>

    private let editViewModel = EditViewModel()
    private let deleteViewModel = DeleteViewModel()

    var body: some View {
        ZStack {
            TextFieldAlertView(
                text: $inputText,
                isShowingAlert: $presentAlert,
                placeholder: "ショップ名",
                title: "ショップの追加",
                message: "入力した内容でショップを追加します",
                leftButtonTitle: "キャンセル",
                rightButtonTitle: "追加",
                leftButtonAction: {
                    // 入力内容の初期化
                    inputText = ""
                },
                rightButtonAction: {
                    // 追加タップ時の処理
                    // 新規ショップ登録処理
                    let newShop = Shop(context: context)
                    newShop.timestamp = Date()
                    newShop.memo = ""
                    newShop.name = inputText

                    try? context.save()
                    // 入力内容の初期化
                    inputText = ""
                }
            ) // TextFieldAlertViewここまで

            TextFieldAlertView(
                text: $inputText,
                isShowingAlert: $presentEditAlert,
                placeholder: "ショップ名",
                title: "ショップの編集",
                message: "入力した内容でショップ編集します",
                leftButtonTitle: "キャンセル",
                rightButtonTitle: "編集",
                leftButtonAction: {
                    // 入力内容の初期化
                    inputText = ""
                },
                rightButtonAction: {
                    // 編集のために渡す値
                    editViewModel.editResult2(viewContext: context, editShop: editShop, context: inputText)
                    // 入力内容の初期化
                    inputText = ""
                }
            ) // TextFieldAlertViewここまで
            VStack {
                HStack(alignment: .center) {
                    Text("SHOP")
                } // HStackここまで

                List {
                    ForEach(shops, id: \.self) { shop in
                        // セルの表示
                        HStack {
                            Text(shop.name!)
                            Spacer()
                            Button(action: {
                                // 編集ダイアログポップアップしたい
                                // actionSheetを表示する
                                isShowAction = true
                                // 編集用に元のショップ名を取得
                                inputText = shop.name!
                                // 編集用に1行データを取得
                                editShop = shop
                            }) {
                                Text("編集 >")
                                    .font(.caption)
                                    .padding(4)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color(.orange), lineWidth: 1.0)
                                    )
                            } // Buttonここまで
                            // List内Button有効化のため適当なstyleをセットしている
                            .buttonStyle(BorderlessButtonStyle())
                        } // HStackここまで

                        // タップできる範囲を拡張する
                        .contentShape(Rectangle())
                        // タップ時の処理
                        .onTapGesture {
                            // タップしたショップ名をわたす
                            self.shopName = shop.name!
                            // 閉じる処理
                            dismiss()
                        } // .onTapGestureここまで
                    } // ForEachここまで
                } // Listここまで
                .foregroundColor(.orange)

                Button(action: {
                    // 閉じる処理
                    dismiss()
                }) {
                    Text("閉じる")
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(.orange)
                } // 閉じるボタンここまで
                Spacer()
            } // VStackここまで

            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        // タップでショップ追加アラート画面表示
                        presentAlert.toggle()
                    }) {
                        // 追加Viewへ遷移する
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .clipShape(Circle())
                    }
                    Text("SHOP追加")
                        .font(.system(size: 8))
                        .foregroundColor(Color.orange)
                    Spacer()
                } // VStackここまで
            } // HStackここまで
        } // ZStackここまで
        .onAppear {
            // ショップが０のとき
            if self.shops.count == 0 {
                /// Listビュー表示時に初期データ登録処理を実行する
                registSampleShopData(context: context)
            }
        } // onAppearここまで
        .actionSheet(isPresented: $isShowAction) {
            // ActionSheet（メニュー構造）構造体は、表示するタイトル、メッセージ、ボタンメニューを定義
            // タイトル
            ActionSheet(title: Text("ショップを編集"),
                        // 補足説明
                        message: Text("編集内容を選択してください"),
                        // ボタンメニュー　配列型
                        buttons: [
                            .default(Text("ショップを削除"), action: {
                                // 削除ロジック
                                deleteViewModel.deleteResult2(viewContext: context, editShop: editShop)
                                // 初期化
                                inputText = ""
                            }),
                            .default(Text("ショップを編集"), action: {
                                // 編集アラート表示
                                presentEditAlert.toggle()
                            }),
                            // キャンセル
                            .cancel()
                        ]) // ActionSheetここまで
        } // actionSheetここまで
    } // bodyここまで
} // ShopListViewここまで

struct ShopListView_Previews: PreviewProvider {
    @State static var shopName = "すべて"

    static var previews: some View {
        ShopListView(shopName: $shopName)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext) // Persistencdファイルのデータを表示する
    }
}
