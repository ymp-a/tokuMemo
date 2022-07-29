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
        ZStack {
            VStack {
                TextField("🔍 検索バー", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                HStack(alignment: .center, spacing: 0) {
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
                .padding(.horizontal)

                Divider()
                    .background(Color.black)

                List {
                    Text("120　商品１\n120 / 個　　スギ薬局中野南台")
                    Text("990　ディアボーテ オイルイン トリ\n4.95 / g  200g")
                    Text("1080　チョコレート効果\n12.85 / 枚　84枚 ドンキホーテ環七")
                    Text("387 ブレンディスティックカフェオレ\n12.9 / 個  30個 Tomod's西新宿五丁目")

                } // Listここまで
                .foregroundColor(.orange)

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
                .padding(.bottom)
                .padding(.bottom)
            } // VStackここまで
        } // ZStackここまで
    } // bodyここまで
} // structここまで

struct TokuMemoListView_Previews: PreviewProvider {
    static var previews: some View {
        TokuMemoListView()
    }
}
