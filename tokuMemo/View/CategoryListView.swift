//
//  CategoryListView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/07/09.
//

import SwiftUI
import CoreData

// https://www.yururiwork.net/archives/1315
struct TextFieldAlertView: UIViewControllerRepresentable {

    @Binding var text: String
    @Binding var isShowingAlert: Bool

    let placeholder: String
    let title: String
    let message: String

    let leftButtonTitle: String?
    let rightButtonTitle: String?

    var leftButtonAction: (() -> Void)?
    var rightButtonAction: (() -> Void)?

    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlertView>) -> some UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<TextFieldAlertView>) {

        guard context.coordinator.alert == nil else {
            return
        }

        if !isShowingAlert {
            return
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        context.coordinator.alert = alert

        alert.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = text
            textField.delegate = context.coordinator
        }

        if leftButtonTitle != nil {
            alert.addAction(UIAlertAction(title: leftButtonTitle, style: .default) { _ in
                alert.dismiss(animated: true) {
                    isShowingAlert = false
                    leftButtonAction?()
                }
            })
        }

        if rightButtonTitle != nil {
            alert.addAction(UIAlertAction(title: rightButtonTitle, style: .default) { _ in
                if let textField = alert.textFields?.first, let text = textField.text {
                    self.text = text
                }
                alert.dismiss(animated: true) {
                    isShowingAlert = false
                    rightButtonAction?()
                }
            })
        }

        DispatchQueue.main.async {
            uiViewController.present(alert, animated: true, completion: {
                isShowingAlert = false
                context.coordinator.alert = nil
            })
        }
    } // updateUIViewControllerここまで

    func makeCoordinator() -> TextFieldAlertView.Coordinator {
        Coordinator(self)
    } // makeCoordinatorここまで

    class Coordinator: NSObject, UITextFieldDelegate {

        var alert: UIAlertController?
        var view: TextFieldAlertView

        init(_ view: TextFieldAlertView) {
            self.view = view
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let text = textField.text as NSString? {
                self.view.text = text.replacingCharacters(in: range, with: string)
            } else {
                self.view.text = ""
            }
            return true
        } // textFieldここまで
    } // Coordinatorここまで
} // TextFieldAlertViewここまで

// 初期データ登録用
func registSampleData(context: NSManagedObjectContext) {

    /// Categoryテーブル初期値
    let categoryList = [
        ["すべて", "", "2022/08/10" ],
        ["食品", "", "2022/08/14"],
        ["日用品", "", "2022/08/18"]
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
    @State private var presentAlert = false

    /// データ取得処理
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.timestamp, ascending: true)],
        predicate: nil
    ) private var categories: FetchedResults<Category>

    var body: some View {
        ZStack {
            TextFieldAlertView(
                text: $inputText,
                isShowingAlert: $presentAlert,
                placeholder: "カテゴリー名",
                title: "カテゴリーの追加",
                message: "入力した内容でカテゴリー追加します",
                leftButtonTitle: "キャンセル",
                rightButtonTitle: "追加",
                leftButtonAction: {
                    // 入力内容の初期化
                    inputText = ""
                },
                rightButtonAction: {
                    // 追加タップ時の処理
                    // カテゴリー新規登録処理
                    let newCategory = Category(context: context)
                    newCategory.timestamp = Date()
                    newCategory.memo = ""
                    newCategory.name = inputText

                    try? context.save()
                    // 入力内容の初期化
                    inputText = ""
                }
            ) // TextFieldAlertViewここまで

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
                        presentAlert.toggle()
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
                registSampleData(context: context)
            }
        } // onAppearここまで
    } // bodyここまで
} // CategoryListViewここまで

struct CategoryListView_Previews: PreviewProvider {
    @State static var categoryName = "すべて"

    static var previews: some View {
        CategoryListView(categoryName: $categoryName)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)  // Persistencdファイルのデータを表示する
    }
}
