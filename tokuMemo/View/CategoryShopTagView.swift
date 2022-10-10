//
//  CategoryShopTagView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/09/15.
//

import SwiftUI

struct CategoryShopTagView: View {
    // カテゴリーテキスト部分
    @Binding var categoryName: String
    // ショップ名テキスト部分
    @Binding var shopName: String
    // カテゴリー画面表示フラグ
    @State var showingModalCategoryListView: Bool = false
    // ショップ画面表示フラグ
    @State var showingModalShopListView: Bool = false

    var body: some View {

        HStack(alignment: .center, spacing: 0) {

            ButtonAction(buttonName: $categoryName)
            ButtonAction(buttonName: $shopName)

        } // HStackここまで
        .font(.title3)
        .foregroundColor(.orange)
        .padding(.horizontal)
    } // bodyここまで
} // CategoryShopTagViewここまで

// Buttonの装飾
struct ButtonTab: View {
    var text: String
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .bold()
            .lineLimit(1)
            .minimumScaleFactor(0.1)
        Image(systemName: "chevron.right.circle")
            .bold()
    }
}

// Buttonのふるまい
struct ButtonAction: View {

    @Binding var buttonName: String

    // カテゴリー画面表示フラグ
    @State private var showingModalListView: Bool = false

    var body: some View {

        Button(action: {
            // ボタンタップでカテゴリ画面フラグオン
            showingModalListView.toggle()
        }) {
            ButtonTab(text: buttonName)
        }
        // カテゴリ画面モーダル表示
        .fullScreenCover(isPresented: $showingModalListView) {
            // 引数でViewを分別
            if buttonName == "categoryName" {
                CategoryListView(categoryName: $buttonName)
            } else {
                ShopListView(shopName: $buttonName)
            }
        }
        .padding(5)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.orange, lineWidth: 3)
        )
    }
}

struct CategoryShopTagView_Previews: PreviewProvider {
    @State static var categoryName = "カテゴリー"
    @State static var shopName = "ショップ"

    static var previews: some View {
        CategoryShopTagView(categoryName: $categoryName, shopName: $shopName)
    }
}
