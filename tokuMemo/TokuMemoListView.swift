//
//  TokuMemoListView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/06/28.
//

import SwiftUI

struct TokuMemoListView: View {
    // メモ検索入力用
    @State private var inputText = ""

    var body: some View {
        VStack {
            TextField("🔍 検索バー", text: $inputText)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            HStack(alignment: .center) {
                Button(action: {
                    // タップしたらカテゴリ選択画面へ遷移したい
                }) {
                    Text("カテゴリー")
                    Image(systemName: "chevron.right.circle")
                }
                .font(.title3)
                .buttonStyle(.bordered)

                Button(action: {
                    // タップしたらショップ選択画面へ遷移したい
                }) {
                    Text("ショップ")
                    Image(systemName: "chevron.right.circle")
                }
                .font(.title3)
                .buttonStyle(.bordered)

            } // HStackここまで
            Divider()
                .background(Color.black)
            // ボタンのViewここから
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    // 追加ボタン
                    Button(action: {
                        // タップで画面表示させる
                    }, label: {
                        // 追加Viewへ遷移する
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(20)
                            .background(Color.orange)
                            .clipShape(Circle())

                    })
                    .padding(20)
                } // HStackここまで
            } // VStackここまで
            Divider()
                .background(Color.black)
            HStack {
                VStack {
                    Image(systemName: "house")
                        .font(.system(size: 30))
                    Text("Top")
                        .font(.system(size: 12))
                } // VStackここまで
                .foregroundColor(.brown)
                .padding(.horizontal)

                VStack {
                    Image(systemName: "cart")
                        .font(.system(size: 30))
                        .padding(.horizontal)
                    Text("買い物リスト")
                        .font(.system(size: 12))
                }
                .foregroundColor(.gray)
                Spacer()
            } // HStackここまで
        } // VStackここまで
    } // bodyここまで
} // structここまで

struct TokuMemoListView_Previews: PreviewProvider {
    static var previews: some View {
        TokuMemoListView()
    }
}
