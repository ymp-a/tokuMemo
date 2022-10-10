//
//  EditItemView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/10/10.
//

import SwiftUI

struct EditItemView: View {
    // モーダル終了処理
    @Environment(\.dismiss) var dismiss
    /// 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // カテゴリーテキスト部分
    @Binding var categoryName: String
    // ショップ名
    @Binding var shopName: String
    // 登録商品
    @State private var inputItem: InputItem = InputItem()
    /// 複数アラート参考 https://zenn.dev/spyc/articles/993fb47a1d42e8
    // 未入力時のアラートフラグ
    @State private var showingAlert = false
    @State private var alertType: AlertType = .itemName

    // アラートの種類
    enum AlertType {
        case itemName
        case itemPrice
        case itemsVolume
    }

    // 参考 https://gist.github.com/takoikatakotako/4493a9fd947e7ceda8a97d04d7ea6c83
    init(categoryName: Binding<String>, shopName: Binding<String>) {
        // navigationTitleカラー変更
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]

        self._categoryName = categoryName
        self._shopName = shopName
    }

    var body: some View {
        VStack(spacing: 0) {
            // Divider()の代わりに利用、色とライン高さ変更可能
            Rectangle()
                .foregroundColor(.orange)
                .frame(height: 1)
            HStack {
                TextField("商品名", text: $inputItem.name)
            }
            .padding(10)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.top)
            .padding(.horizontal)
            // カテゴリーショップボタン
            CategoryShopTagView(categoryName: $categoryName, shopName: $shopName)
                .padding(.bottom)

            HStack {
                TextField("税込価格", text: $inputItem.price)
                    .keyboardType(.numberPad)
            }
            .padding(10)
            .frame(height: 50)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.horizontal)

            HStack {
                TextField("値引価格", text: $inputItem.discountPrice)
                    .keyboardType(.numberPad)
            }
            .padding(10)
            .frame(height: 50)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.horizontal)

            HStack {
                TextField("数量", text: $inputItem.volume)
                    .keyboardType(.numberPad)
                Picker(selection: $inputItem.selection, label: Text("数量単位を選択")) {
                    ForEach(0 ..< inputItem.units.count, id: \.self) { num in
                        Text(self.inputItem.units[num])
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
                TextField("メモを入力", text: $inputItem.memo)
            }
            .padding(10)
            .frame(height: 50)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.horizontal)
            Button(action: {
                // 登録タップ時の処理
                // 入力チェック
                if inputItem.name.count<1 {
                    alertType = .itemName
                    showingAlert.toggle()
                } else if inputItem.price.count<1 {
                    alertType = .itemPrice
                    showingAlert.toggle()
                } else if inputItem.volume.count<1 {
                    alertType = .itemsVolume
                    showingAlert.toggle()
                } else {
                    // 入力チェックがOKなら
                    // 商品編集登録処理
//                    let newItem = Item(context: context)
//                    newItem.itemName = inputItem.name
//                    newItem.categoryName = categoryName
//                    newItem.shopName = shopName
//                    newItem.price = Int32(inputItem.price) ?? 0
//                    newItem.discountPrice = Int32(inputItem.discountPrice) ?? 0
//                    newItem.volume = Int32(inputItem.volume) ?? 0
//                    newItem.qtyunit = Int32(exactly: inputItem.selection) ?? 0
//                    newItem.memo = inputItem.memo
//                    newItem.timestamp = Date()
//
//                    try? context.save()

                    // 画面を閉じる
                    dismiss()
                }
            }) {
                Text("商品を編集する")
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
        .navigationBarTitle("商品名を編集", displayMode: .inline)
    } // bodyここまで
} // AddItemViewここまで

struct EditItemView_Previews: PreviewProvider {
    @State static var categoryName = "カテゴリー"
    @State static var shopName = "ショップ"

    static var previews: some View {
        EditItemView(categoryName: $categoryName, shopName: $shopName)
    }
}
