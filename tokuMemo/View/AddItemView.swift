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
    // 商品名
    @State private var inputItemName = ""
    // カテゴリー
    @Binding var categoryText: String
    // 商品価格
    @State var inputItemPrice = ""
    // 値引金額
    @State private var inputDiscountPrice = ""
    // 数量
    @State private var inputItemsVolume = ""
    // 数量単位
    private let units = ["個", "g", "ml"]
    // ピッカー初期値
    @State private var selection = 1
    // メモ
    @State private var inputItemMemo = ""
    // 参考 https://gist.github.com/takoikatakotako/4493a9fd947e7ceda8a97d04d7ea6c83
    init(categoryText: Binding<String>) {
        // navigationTitleカラー変更
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]

        self._categoryText = categoryText
    }
    // カテゴリー画面表示フラグ
    @State private var showingModalCategoryListView = false
    // ショップ画面表示フラグ
    @State private var showingModalShopListView = false

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                // Divider()の代わりに利用、色とライン高さ変更可能
                .foregroundColor(.orange)
                .frame(height: 1)
            HStack {
                Text("商品名")
                TextField("", text: $inputItemName)
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
                    Text("\(categoryText)")
                        .frame(maxWidth: .infinity)
                    Image(systemName: "chevron.right.circle")
                }
                // カテゴリ画面モーダル表示
                .fullScreenCover(isPresented: $showingModalCategoryListView) {
                    CategoryListView()
                }

                Button(action: {
                    // ボタンタップでショップ画面フラグオン
                    showingModalShopListView.toggle()
                }) {
                    Text("ショップ")
                        .frame(maxWidth: .infinity)
                    Image(systemName: "chevron.right.circle")
                }
                // カテゴリ画面モーダル表示
                .fullScreenCover(isPresented: $showingModalShopListView) {
                    ShopListView()
                }
            } // HStackここまで
            .font(.title3)
            .buttonStyle(.bordered)
            .padding(.bottom)
            .padding(.horizontal)
            HStack {
                Text("税込価格")
                TextField("", text: $inputItemPrice)
            }
            .padding(10)
            .frame(height: 50)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.horizontal)

            HStack {
                Text("値引き金額")
                TextField("", text: $inputDiscountPrice)
            }
            .padding(10)
            .frame(height: 50)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.horizontal)

            HStack {
                Text("数量")
                TextField("", text: $inputItemsVolume)
                Picker(selection: $selection, label: Text("数量単位を選択")) {
                    ForEach(units, id: \.self) { unit in
                        Text(unit)
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
                dismiss()
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
        .navigationBarTitle("商品名を登録", displayMode: .inline)
    } // bodyここまで
} // AddItemViewここまで

struct AddItemView_Previews: PreviewProvider {

    @State static var categoryText = "すべて"

    static var previews: some View {
        AddItemView(categoryText: $categoryText)
    }
}
