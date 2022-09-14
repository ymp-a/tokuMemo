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

    @State private var inputText = ""
    @State private var presentAlert = false
    // ショップ名テキスト部分
    @Binding var shopText: String

    /// 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context

    /// データ取得処理
    @FetchRequest(
        entity: Shop.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Shop.timestamp, ascending: true)],
        predicate: nil
    ) private var shops: FetchedResults<Shop>

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
                        } // HStackここまで

                        // タップできる範囲を拡張する
                        .contentShape(Rectangle())
                        // タップ時の処理
                        .onTapGesture {
                            // タップしたショップ名をわたす
                            self.shopText = shop.name!
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
    } // bodyここまで
} // CategoryListViewここまで

// struct ShopListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopListView()
//    }
// }
