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
    // 商品情報
    @Binding var editItem: Item?
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
    init(categoryName: Binding<String>, shopName: Binding<String>, editItem: Binding<Item?>) {
        // navigationTitleカラー変更
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]

        self._categoryName = categoryName
        self._shopName = shopName
        self._editItem = editItem
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
                    editItem!.itemName = inputItem.name
                    editItem!.categoryName = categoryName
                    editItem!.shopName = shopName
                    editItem!.price = Int32(inputItem.price) ?? 0
                    editItem!.discountPrice = Int32(inputItem.discountPrice) ?? 0
                    editItem!.volume = Int32(inputItem.volume) ?? 0
                    editItem!.qtyunit = Int32(exactly: inputItem.selection) ?? 0
                    editItem!.memo = inputItem.memo
                    editItem!.timestamp = Date()

                    try? context.save()

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
        .onAppear() {
            inputItem.name = editItem!.itemName!
            inputItem.price = String(editItem!.price)
            inputItem.discountPrice = String(editItem!.discountPrice)
            inputItem.volume = String(editItem!.volume)
            inputItem.selection = Int(editItem!.qtyunit)
            inputItem.memo = editItem!.memo!
        } // onAppearここまで
        .navigationBarTitle("商品名を編集", displayMode: .inline)
    } // bodyここまで
} // AddItemViewここまで

// struct EditItemView_Previews: PreviewProvider {
//    static var persistenceController = PersistenceController.shared
//    @State static var categoryName = "カテゴリー"
//    @State static var shopName = "ショップ"
//    @State static var editItem: Item {
//        let editItem = Item()
//        editItem.itemName = "いろはす"
//        editItem.categoryName = "すべて"
//        editItem.shopName = "すべて"
//        editItem.price = 85
//        editItem.discountPrice = 0
//        editItem.volume = 1000
//        editItem.qtyunit = 2
//        editItem.memo = ""
//        editItem.timestamp = Date()
//        return editItem
//    }
//
//    static var previews: some View {
//        EditItemView(categoryName: $categoryName, shopName: $shopName, editItem: $editItem) .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
// }
