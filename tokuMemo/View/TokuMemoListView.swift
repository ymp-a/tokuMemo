//
//  TokuMemoListView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/06/28.
//

import SwiftUI

struct TokuMemoListView: View {
    /// 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // メモ検索入力用
    @State private var inputText = ""
    // カテゴリーテキスト部分
    @State private var categoryName: String = "カテゴリー"
    // ショップ名テキスト部分
    @State private var shopName: String = "ショップ"

    /// データ取得処理
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        predicate: nil
    ) private var items: FetchedResults<Item>

    private let deleteViewModel = DeleteViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    TextField("🔍 検索バー", text: $inputText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)

                    // カテゴリーショップボタン
                    CategoryShopTagView(categoryName: $categoryName, shopName: $shopName)

                    List {
                        ForEach(items, id: \.self) { item in
                            Text("¥\(item.price)      \(item.itemName!)")
                        }
                        .onDelete { indexSet in
                            deleteViewModel.deleteResult(offsets: indexSet, result: items, viewContext: context)
                        } // onDeleteここまで
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
                            NavigationLink(destination: AddItemView(categoryName: $categoryName, shopName: $shopName)) {
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
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext) // Persistencdファイルのデータを表示する
    }
}
