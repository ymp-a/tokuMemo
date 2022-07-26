//
//  AddItemView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/07/25.
//

import SwiftUI

struct AddItemView: View {
    // 商品名
    @State private var inputItemName = ""
    // 商品価格
    @State private var inputItemPrice = ""
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

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text("商品名を登録")
                    .foregroundColor(.orange)
                    .padding(.bottom)
            } // HStackここまで
            Divider()
                .background(Color.black)
            HStack {
                Text("商品名")
                TextField("", text: $inputItemName)
            }
            .padding(10)
            .foregroundColor(.orange)
            .border(.orange)
            .padding(.top)
            .padding(.horizontal)

            HStack (alignment: .center, spacing: 0) {
                Button(action: {
                    // タップしたらカテゴリ選択画面へ遷移したい
                }) {
                    Text("カテゴリー")
                        .frame(maxWidth: .infinity)
                    Image(systemName: "chevron.right.circle")
                }

                Button(action: {
                    // タップしたらショップ選択画面へ遷移したい
                }) {
                    Text("ショップ")
                        .frame(maxWidth: .infinity)
                    Image(systemName: "chevron.right.circle")
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
    } // bodyここまで
} // AddItemViewここまで

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
