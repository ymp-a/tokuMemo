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
    // カテゴリー画面表示フラグ
    @State private var showingModalCategoryListView = false
    // ショップ画面表示フラグ
    @State private var showingModalShopListView = false

    var body: some View {
        ZStack {
            VStack {
                TextField("🔍 検索バー", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                HStack(alignment: .center, spacing: 0) {
                    Button(action: {
                        // ボタンタップでカテゴリ画面フラグオン
                        showingModalCategoryListView.toggle()
                    }) {
                        Text("カテゴリー")
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
                }// HStackここまで
                .font(.title3)
                .buttonStyle(.bordered)
                .padding(.horizontal)

                List {
                    Text("120　商品１\n120 / 個　　スギ薬局中野南台")
                    Text("990　ディアボーテ オイルイン トリ\n4.95 / g  200g")
                    Text("1080　チョコレート効果\n12.85 / 枚　84枚 ドンキホーテ環七")
                    Text("387 ブレンディスティックカフェオレ\n12.9 / 個  30個 Tomod's西新宿五丁目")

                } // Listここまで
                .foregroundColor(.orange)

                TabView {
                    Text("") // 1枚目の子ビュー
                        .tabItem {
                            Image(systemName: "house")
                            Text("Top")
                        }
                    Text("") // 買い物リストView
                        .tabItem {
                            Image(systemName: "cart")
                            Text("買い物リスト")
                        }
                } // TabViewここまで
                .frame(width: .infinity, height: 40, alignment: .bottom)
                .accentColor(.orange) // 選択中の色指定
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
                .padding(.bottom, 30)
            } // VStackここまで
        } // ZStackここまで
    } // bodyここまで
} // structここまで

struct TokuMemoListView_Previews: PreviewProvider {
    static var previews: some View {
        TokuMemoListView()
    }
}
