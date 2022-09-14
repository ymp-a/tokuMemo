//
//  AddItemView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/07/25.
//

import SwiftUI

struct AddItemView: View {
    // モーダル終了処理
    @Environment(\.dismiss) var dismiss
    /// 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // 商品名
    @State private var inputItemName = ""
    // カテゴリーテキスト部分
    @Binding var categoryName: String
    // ショップ名テキスト部分
    @Binding var shopText: String
    // 商品価格
    @State private var inputItemPrice = ""
    // 値引金額
    @State private var inputDiscountPrice = ""
    // 数量
    @State private var inputItemsVolume = "1"
    // 数量単位
    private let units = ["個", "g", "ml"]
    // ピッカー初期値
    @State private var selection = 0
    // メモ
    @State private var inputItemMemo = ""
    /// 複数アラート参考 https://zenn.dev/spyc/articles/993fb47a1d42e8
    // 未入力時のアラートフラグ用
    @State private var showingAlert = false
    @State private var alertType: AlertType = .itemName
    // アラートの種類
    enum AlertType {
        case itemName
        case itemPrice
        case itemsVolume
    }

    // 参考 https://gist.github.com/takoikatakotako/4493a9fd947e7ceda8a97d04d7ea6c83
    init(categoryName: Binding<String>, shopText: Binding<String>) {
        // navigationTitleカラー変更
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]

        self._categoryName = categoryName
        self._shopText = shopText
    }
    // カテゴリー画面表示フラグ
    @State private var showingModalCategoryListView = false
    // ショップ画面表示フラグ
    @State private var showingModalShopListView = false

    var body: some View {
        VStack(spacing: 0) {
            // Divider()の代わりに利用、色とライン高さ変更可能
            Rectangle()
                .foregroundColor(.orange)
                .frame(height: 1)
            HStack {
                TextField("商品名", text: $inputItemName)
            }
            .padding(10)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.top)
            .padding(.horizontal)

            HStack(alignment: .center, spacing: 0) {
                Button(action: {
                    // ボタンタップでカテゴリ画面フラグオン
                    showingModalCategoryListView.toggle()
                }) {
                    Text(categoryName)
                        .frame(maxWidth: .infinity)
                    Image(systemName: "chevron.right.circle")
                }
                // カテゴリ画面モーダル表示
                .fullScreenCover(isPresented: $showingModalCategoryListView) {
                    CategoryListView(categoryName: $categoryName)
                }

                Button(action: {
                    // ボタンタップでショップ画面フラグオン
                    showingModalShopListView.toggle()
                }) {
                    Text(shopText)
                        .frame(maxWidth: .infinity)
                    Image(systemName: "chevron.right.circle")
                }
                // カテゴリ画面モーダル表示
                .fullScreenCover(isPresented: $showingModalShopListView) {
                    ShopListView(shopText: $shopText)
                }
            } // HStackここまで
            .font(.title3)
            .buttonStyle(.bordered)
            .padding(.bottom)
            .padding(.horizontal)
            HStack {
                TextField("税込価格", text: $inputItemPrice)
                    .keyboardType(.numberPad)
            }
            .padding(10)
            .frame(height: 50)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.horizontal)

            HStack {
                TextField("値引き価格", text: $inputDiscountPrice)
                    .keyboardType(.numberPad)
            }
            .padding(10)
            .frame(height: 50)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.horizontal)

            HStack {
                TextField("数量", text: $inputItemsVolume)
                    .keyboardType(.numberPad)
                Picker(selection: $selection, label: Text("数量単位を選択")) {
                    ForEach(0 ..< units.count, id: \.self) { num in
                        Text(self.units[num])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())    // セグメントピッカースタイルの指定
                .frame(width: 200)
            }
            .padding(10)
            .frame(height: 50)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.horizontal)

            HStack {
                TextField("メモを入力", text: $inputItemMemo)
            }
            .padding(10)
            .frame(height: 50)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.horizontal)
            Button(action: {
                // 登録タップ時の処理
                // 入力チェック
                if inputItemName.count<1 {
                    alertType = .itemName
                    showingAlert.toggle()
                } else if inputItemPrice.count<1 {
                    alertType = .itemPrice
                    showingAlert.toggle()
                } else if inputItemsVolume.count<1 {
                    alertType = .itemsVolume
                    showingAlert.toggle()
                } else {
                    // 入力チェックがOKなら
                    // 商品登録処理
                    let newItem = Item(context: context)
                    newItem.itemName = inputItemName
                    newItem.categoryName = categoryName
                    newItem.shopName = shopText
                    newItem.price = Int32(inputItemPrice) ?? 0
                    newItem.discountPrice = Int32(inputDiscountPrice) ?? 0
                    newItem.volume = Int32(inputItemsVolume) ?? 0
                    newItem.qtyunit = Int32(exactly: selection) ?? 0
                    newItem.memo = inputItemMemo
                    newItem.timestamp = Date()

                    try? context.save()

                    // 画面を閉じる
                    dismiss()
                }
            }) {
                Text("商品を登録する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .font(.title3)
                    .foregroundColor(.white)
                    .background(.orange)
                    .padding(.horizontal)
            } // 登録ボタンここまで
            Spacer()
        } // VStackここまで
        // showingAlertがtureのとき表示する
        .alert(isPresented: $showingAlert) {
            // アラートタイプに応じたメッセージを表示する
            switch alertType {
            case .itemName:
                return Alert(title: Text("商品名を入力してください"))
            case .itemPrice:
                return Alert(title: Text("商品の税込金額を入力してください"))
            case .itemsVolume:
                return Alert(title: Text("商品の数を入力してください"))
            } // alertTypeここまで
        } // alertここまで
        .navigationBarTitle("商品名を登録", displayMode: .inline)
    } // bodyここまで
} // AddItemViewここまで

struct AddItemView_Previews: PreviewProvider {
    @State static var categoryName = "カテゴリー"
    @State static var shopText = "ショップ"

    static var previews: some View {
        AddItemView(categoryName: $categoryName, shopText: $shopText)
    }
}
