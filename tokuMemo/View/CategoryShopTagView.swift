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
        VStack(spacing: 5) {
            HStack(alignment: .center, spacing: 25) {
                Image(systemName: "list.bullet").bold()
                Text("カテゴリ")
                Spacer(minLength: 0)
                Image(systemName: "house.fill").bold()
                Text("ショップ")
                Spacer(minLength: 5)
            }
            .padding(.horizontal)
            HStack(alignment: .center, spacing: 0) {
                ButtonAction(buttonName: $categoryName, label: "category")
                ButtonAction(buttonName: $shopName, label: "shop")
            } // HStackここまで

        } // VStackここまで
        .foregroundColor(.orange)
        .padding(.horizontal)
        .font(.title3)

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

    // フラグ用
    var label = ""
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
            if label == "category" {
                CategoryListView(categoryName: $buttonName)
            } else {
                ShopListView(shopName: $buttonName)
            }

        } // fullScreenCoverここまで
        .padding(5)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.orange, lineWidth: 3)
        )
    }
}

struct CategoryShopTagView_Previews: PreviewProvider {
    @State static var categoryName = "すべて"
    @State static var shopName = "すべて"

    static var previews: some View {
        CategoryShopTagView(categoryName: $categoryName, shopName: $shopName)
    }
}
