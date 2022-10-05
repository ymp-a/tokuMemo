//
//  CategoryListView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/07/09.
//

import SwiftUI
import CoreData

// 初期データ登録用
func registSampleCategoryData(context: NSManagedObjectContext) {

    /// Categoryテーブル初期値
    let categoryList = [
        ["すべて", "All", "2022/08/10" ],
        ["食品", "飲料含む", "2022/08/14"],
        ["日用品", "サンプル", "2022/08/18"]
    ]

    /// カテゴリーテーブル全消去
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
    fetchRequest.entity = Category.entity()
    let categories = try? context.fetch(fetchRequest) as? [Category]
    for category in categories! {
        context.delete(category)
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/M/d"

    /// カテゴリーテーブル登録
    for category in categoryList {
        let newCategory = Category(context: context)
        newCategory.name = category[0]         // カテゴリー名
        newCategory.memo = category[1]        // メモ
        newCategory.timestamp = dateFormatter.date(from: category[2])! // 追加日
    }

    /// コミット
    try? context.save()
}

struct CategoryListView: View {
    // モーダル終了処理
    @Environment(\.dismiss) var dismiss
    /// 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    // カテゴリー
    @Binding var categoryName: String

    @State private var inputText = ""

    @State private var inputMemo = ""
    // カテゴリ追加アラート表示
    @State private var presentAddAlert = false
    // カテゴリ編集アラート表示
    @State private var presentEditAlert = false
    // モディファイアView表示
    @State private var isShowAction = false
    // タップした行の情報を渡す
    @State private var editCategory: Category?
    /// データ取得処理
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.timestamp, ascending: true)],
        predicate: nil
    ) private var categories: FetchedResults<Category>

    private let editViewModel = EditViewModel()
    private let deleteViewModel = DeleteViewModel()

    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center) {
                    Text("カテゴリー（大分類）")
                } // HStackここまで

                List {
                    ForEach(categories, id: \.self) { category in
                        // セルの表示
                        HStack {
                            Text(category.name!)
                            Spacer()
                            Button(action: {
                                // 編集ダイアログポップアップ
                                // actionSheetを表示する
                                isShowAction = true
                                // 編集用のカテゴリー名を取得
                                inputText = category.name!
                                // 編集用のカテゴリーメモを取得
                                inputMemo = category.memo!
                                // 編集用に1行データを取得
                                editCategory = category
                            }) {
                                Text("編集 >")
                                    .font(.caption)
                                    .padding(4)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color(.orange), lineWidth: 1.0)
                                    )
                            } // Buttonここまで
                            // List内Button有効化のため適当なstyleをセットしている
                            .buttonStyle(BorderlessButtonStyle())
                        } // HStackここまで

                        // タップできる範囲を拡張する
                        .contentShape(Rectangle())
                        // タップ時の処理
                        .onTapGesture {
                            // タップしたカテゴリー名わたす
                            self.categoryName = category.name!
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
                        // タップでカテゴリー追加アラートを表示
                        presentAddAlert.toggle()
                    }) {
                        // 追加Viewへ遷移する
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .clipShape(Circle())
                    }
                    Text("カテゴリ追加")
                        .font(.system(size: 8))
                        .foregroundColor(Color.orange)
                    Spacer()
                } // VStackここまで
            } // HStackここまで
        } // ZStackここまで
        .onAppear {
            // カテゴリー名が０のとき
            if self.categories.count == 0 {
                /// Listビュー表示時に初期データ登録処理を実行する
                registSampleCategoryData(context: context)
            }
        } // onAppearここまで
        .actionSheet(isPresented: $isShowAction) {
            // ActionSheet（メニュー構造）構造体は、表示するタイトル、メッセージ、ボタンメニューを定義
            // タイトル
            ActionSheet(title: Text("カテゴリーを編集"),
                        // 補足説明
                        message: Text("編集内容を選択してください"),
                        // ボタンメニュー　配列型
                        buttons: [
                            .default(Text("カテゴリーを削除"), action: {
                                // 削除ロジック
                                deleteViewModel.deleteResult(viewContext: context, editRow: editCategory!)
                                // 初期化
                                inputText = ""
                            }),
                            .default(Text("カテゴリーを編集"), action: {
                                // 編集アラート表示
                                presentEditAlert.toggle()
                            }),
                            // キャンセル
                            .cancel()
                        ]) // ActionSheetここまで
        } // actionSheetここまで

        .alert("カテゴリー追加", isPresented: $presentAddAlert, actions: {
            TextField("カテゴリー名", text: $inputText)

            TextField("メモ", text: $inputMemo)

            Button("追加", action: {
                // 追加タップ時の処理
                // カテゴリー新規登録処理
                let newCategory = Category(context: context)
                newCategory.timestamp = Date()
                newCategory.memo = inputMemo
                newCategory.name = inputText

                try? context.save()
                // 入力内容の初期化
                inputText = ""
                inputMemo = ""
            })
            Button("Cancel", role: .cancel, action: {// 入力内容の初期化
                inputText = ""
                inputMemo = ""
            })
        }, message: {
            Text("入力した内容でカテゴリー追加します")
        })

        .alert("カテゴリー編集", isPresented: $presentEditAlert, actions: {
            TextField("カテゴリー名", text: $inputText)

            TextField("メモ", text: $inputMemo)

            Button("編集", action: {
                // 編集のために渡す値
                editViewModel.editResult(viewContext: context, editCategory: editCategory, context: inputText, memo: inputMemo)
                // 入力内容の初期化
                inputText = ""
                inputMemo = ""
            })
            Button("Cancel", role: .cancel, action: {// 入力内容の初期化
                inputText = ""
                inputMemo = ""
            })
        }, message: {
            Text("入力した内容でカテゴリー追加します")
        })
    } // bodyここまで
} // CategoryListViewここまで

struct CategoryListView_Previews: PreviewProvider {
    @State static var categoryName = "すべて"

    static var previews: some View {
        CategoryListView(categoryName: $categoryName)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)  // Persistencdファイルのデータを表示する
    }
}
