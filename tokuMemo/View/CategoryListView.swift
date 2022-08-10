//
//  CategoryListView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/07/09.
//

import SwiftUI

/// https://dev.classmethod.jp/articles/ios-alert-with-text-field/
struct AlertControllerWithTextFieldContainer: UIViewControllerRepresentable {

    @Binding var textFieldText: String
    @Binding var isPresented: Bool

    let title: String?
    let message: String?
    let placeholderText: String

    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }

    // SwiftUIから新しい情報を受け、viewControllerが更新されるタイミングで呼ばれる
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // TextFieldの追加
        alert.addTextField { textField in
            textField.placeholder = placeholderText
            textField.returnKeyType = .done
        }

        // 決定ボタンアクション
        let doneAction = UIAlertAction(title: "追加", style: .default) { _ in
            if let textField = alert.textFields?.first,
               let text = textField.text {
                textFieldText = text
            }
        }

        // キャンセルボタンアクション
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)

        alert.addAction(cancelAction)
        alert.addAction(doneAction)

        DispatchQueue.main.async {
            uiViewController.present(alert, animated: true) {
                isPresented = false
            }
        }
    }
}

// カスタムModifierの定義
struct AlertWithTextField: ViewModifier {
    @Binding var textFieldText: String
    @Binding var isPresented: Bool

    let title: String?
    let message: String?
    let placeholderText: String

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                AlertControllerWithTextFieldContainer(textFieldText: $textFieldText,
                                                      isPresented: $isPresented,
                                                      title: title,
                                                      message: message,
                                                      placeholderText: placeholderText)
            }
        }
    }
}

extension View {
    // カスタムModifierのメソッド名を alertWithTextField に置き換え
    func alertWithTextField(_ text: Binding<String>, isPresented: Binding<Bool>, title: String?, message: String?, placeholderText: String) -> some View {
        self.modifier(AlertWithTextField(textFieldText: text,
                                         isPresented: isPresented,
                                         title: title,
                                         message: message,
                                         placeholderText: placeholderText))
    }
}

struct Category: Identifiable {
    var id = UUID()
    var name: String

    init(_ name: String) {
        self.name = name
    } // initここまで
} // Categoryここまで

struct CategoryListView: View {
    // サンプルデータ用
    @State var categories: [Category] = [
        Category("すべて"),
        Category("日用品"),
        Category("食品")
    ]
    // モーダル終了処理
    @Environment(\.dismiss) var dismiss

    @State private var inputText = ""
    @State private var presentAlert = false

    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center) {
                    Text("カテゴリー（大分類）")
                } // HStackここまで

                List {
                    ForEach(categories) { category in
                        // セルの表示
                        HStack {
                            Text(category.name)
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
        .alertWithTextField($inputText,
                            isPresented: $presentAlert,
                            title: "カテゴリー入力",
                            message: "追加するカテゴリーを入力下さい",
                            placeholderText: "新規カテゴリー")

    } // bodyここまで
} // CategoryListViewここまで

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
