//
//  ShopListView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/07/13.
//

import SwiftUI

struct Shop: Identifiable {
    var id = UUID()
    var name: String

    init(_ name: String) {
        self.name = name
    } // initここまで
} // Shopここまで

struct ShopListView: View {
    // サンプルデータ用
    @State var shops: [Shop] = [
        Shop("すべて"),
        Shop("サンドラッグ新宿通り店")
    ]
    // モーダル終了処理
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center) {
                    Text("SHOP")
                } // HStackここまで

                List {
                    ForEach(shops) { shop in
                        // セルの表示
                        HStack {
                            Text(shop.name)
                            Spacer()
                        } // HStackここまで

                        // タップできる範囲を拡張する
                        .contentShape(Rectangle())
                        // タップ時の処理
                        .onTapGesture {
                            // タップしたカテゴリー名をTokuMemoListViewのカテゴリーボタンへ渡したい
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
                        // タップで画面表示させる
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
    } // bodyここまで
} // CategoryListViewここまで

struct ShopListView_Previews: PreviewProvider {
    static var previews: some View {
        ShopListView()
    }
}
