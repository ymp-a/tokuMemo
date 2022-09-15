//
//  CategoryShopTagView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/09/15.
//

import SwiftUI

struct CategoryShopTagView: View {
    // カテゴリー画面表示フラグ
    @Binding var showingModalCategoryListView: Bool
    // ショップ画面表示フラグ
    @Binding var showingModalShopListView: Bool
    // カテゴリーテキスト部分
    @Binding var categoryName: String
    // ショップ名テキスト部分
    @Binding var shopName: String

    var body: some View {

        HStack(alignment: .center, spacing: 0) {
            Button(action: {
                // ボタンタップでカテゴリ画面フラグオン
                showingModalCategoryListView.toggle()
            }) {
                Text(categoryName)
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
                Text(shopName)
                    .frame(maxWidth: .infinity)
                Image(systemName: "chevron.right.circle")
            }
            // カテゴリ画面モーダル表示
            .fullScreenCover(isPresented: $showingModalShopListView) {
                ShopListView(shopName: $shopName)
            }
        } // HStackここまで
        .font(.title3)
        .buttonStyle(.bordered)
        .padding(.horizontal)

    } // bodyここまで
} // CategoryShopTagViewここまで

struct CategoryShopTagView_Previews: PreviewProvider {
    @State static var showingModalCategoryListView = false
    @State static var showingModalShopListView = false
    @State static var categoryName = "カテゴリー"
    @State static var shopName = "ショップ"

    static var previews: some View {
        CategoryShopTagView(showingModalCategoryListView: $showingModalCategoryListView, showingModalShopListView: $showingModalShopListView, categoryName: $categoryName, shopName: $shopName)
    }
}
