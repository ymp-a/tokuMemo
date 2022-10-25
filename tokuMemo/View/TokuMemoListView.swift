//
//  TokuMemoListView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/06/28.
//

// import CoreData
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
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]
    ) private var items: FetchedResults<Item>

    private let deleteViewModel = DeleteViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
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
                    // 参考 https://qiita.com/surfinhamster/items/6e0f8aba2cc122e8ccb5#ios15%E4%BB%A5%E9%99%8D%E3%81%AE%E6%96%B9%E6%B3%952022%E5%B9%B43%E6%9C%884%E6%97%A5%E8%BF%BD%E8%A8%98
                    .onChange(of: categoryName) { _ in
                        refineTags()
                    }
                    .onChange(of: shopName) { _ in
                        refineTags()
                    }
                    TabView {
                        Text("") // 1枚目の子ビュー
                            .tabItem {
                                Image(systemName: "house")
                                Text("Top")
                            }
                        //                        Text("") // 買い物リストView
                        //                            .tabItem {
                        //                                Image(systemName: "cart")
                        //                                Text("買い物リスト")
                        //                            }
                    } // TabViewここまで
                    .frame(height: 46, alignment: .bottom)
                    .accentColor(.orange) // 選択中の色指定
                } // VStackここまで
                // ボタンのViewここから
                VStack {
                    Spacer()
                    // 追加ボタン
                    Button(action: {}, label: {
                        // 追加Viewへ遷移する
                        NavigationLink(destination: AddItemView(categoryName: $categoryName, shopName: $shopName)) {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding(14)
                                .background(Color.orange)
                                .clipShape(Circle())
                        } // NavigationLinkここまで
                    })
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

    // タグ絞り込み条件セット
    func refineTags() {
        if categoryName == "カテゴリー" || categoryName == "すべて" {
            if shopName == "ショップ" || shopName == "すべて" {
                // 全カテゴリー全ショップ
                items.nsPredicate = nil
            } else {
                // 全カテゴリー個別ショップ
                items.nsPredicate = NSPredicate(format: "shopName == %@", shopName)
            }
        } else {
            if shopName == "ショップ" || shopName == "すべて" {
                // 個別カテゴリー全ショップ
                items.nsPredicate = NSPredicate(format: "categoryName == %@", categoryName)
            } else {
                // 個別カテゴリー個別ショップ
                items.nsPredicate = NSPredicate(format: "categoryName == %@ and shopName == %@", categoryName, shopName)
            }
        }
    } // combinationTagここまで
} // structここまで

struct TokuMemoListView_Previews: PreviewProvider {

    static var previews: some View {
        TokuMemoListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext) // Persistencdファイルのデータを表示する
    }
}
