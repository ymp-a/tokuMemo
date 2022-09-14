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
    // カテゴリーテキスト部分
    @State private var categoryName: String = "カテゴリー"
    // ショップ名テキスト部分
    @State private var shopText: String = "ショップ"

    /// データ取得処理
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        predicate: nil
    ) private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
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
                            Text("\(categoryName)")
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
                            Text("\(shopText)")
                                .frame(maxWidth: .infinity)
                            Image(systemName: "chevron.right.circle")
                        }
                        // カテゴリ画面モーダル表示
                        .fullScreenCover(isPresented: $showingModalShopListView) {
                            ShopListView(shopText: $shopText)
                        }
                    }// HStackここまで
                    .font(.title3)
                    .buttonStyle(.bordered)
                    .padding(.horizontal)

                    List {
                        ForEach(items, id: \.self) { item in
                            Text("¥\(item.price)"+"    "+"\(item.itemName!)")
                        }
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
                    .frame(height: 40, alignment: .bottom)
                    .accentColor(.orange) // 選択中の色指定
                } // VStackここまで
                // ボタンのViewここから
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        // 追加ボタン
                        Button(action: {}, label: {
                            // 追加Viewへ遷移する
                            NavigationLink(destination: AddItemView(categoryName: $categoryName, shopText: $shopText)) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding(20)
                                    .background(Color.orange)
                                    .clipShape(Circle())
                            } // NavigationLinkここまで
                        })
                        .padding(20)
                    } // HStackここまで
                    .padding(.bottom, 30)
                } // VStackここまで
            } // ZStackここまで
        } // NavigationViewここまで
    } // bodyここまで
} // structここまで

struct TokuMemoListView_Previews: PreviewProvider {

    static var previews: some View {
        TokuMemoListView()
    }
}
