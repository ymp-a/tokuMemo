//
//  CategoryListView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/07/09.
//

import SwiftUI

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
    }

    func makeCoordinator() -> TextFieldAlertView.Coordinator {
        Coordinator(self)
    }

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
        }
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
                    // 追加タップ時の処理　CoreDateへ追加
                }
            ) // TextFieldAlertViewここまで

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
    } // bodyここまで
} // CategoryListViewここまで

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
