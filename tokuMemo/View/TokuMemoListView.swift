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
    // モディファイアView表示
    @State private var isShowAction = false
    // EditItemView表示
    @State private var isPresented: Bool = false
    // タップした行の情報を渡す
    @State private var editItem: Item?

    /// データ取得処理
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        predicate: nil
    ) private var items: FetchedResults<Item>

    private let deleteViewModel = DeleteViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TextField("🔍 検索バー", text: $inputText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)

                    // カテゴリーショップボタン
                    CategoryShopTagView(categoryName: $categoryName, shopName: $shopName)

                    List {
                        ForEach(items, id: \.self) { item in
                            HStack {
                                Text("¥\(item.price)      \(item.itemName!)")
                                Spacer()
                                Button(action: {
                                    // 編集ダイアログポップアップ
                                    // actionSheetを表示する
                                    isShowAction = true
                                    // 編集用に1行データを取得
                                    editItem = item

                                }) {
                                    Image(systemName: "ellipsis.circle.fill")
                                } // Buttonここまで
                                // List内Button有効化のため適当なstyleをセットしている
                                .buttonStyle(BorderlessButtonStyle())
                            } // HStackここまで
                        } // ForEachここまで
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

            // 3点リーダータップのダイアログ表示
            .confirmationDialog("商品の編集", isPresented: $isShowAction, titleVisibility: .visible) {
                Button("商品の削除") {
                    deleteViewModel.deleteResult(viewContext: context, editRow: editItem!)
                }
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Text("商品の編集")
                })
                .navigationDestination(isPresented: $isPresented) {
                    EditItemView(categoryName: $categoryName, shopName: $shopName, editItem: $editItem)
                }// navigationDestinationここまで
            } message: {
                Text("編集内容を選択してください").bold()
            } // confirmationDialogここまで
        } // NavigationStackここまで
    } // bodyここまで
} // structここまで

struct TokuMemoListView_Previews: PreviewProvider {

    static var previews: some View {
        TokuMemoListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext) // Persistencdファイルのデータを表示する
    }
}
