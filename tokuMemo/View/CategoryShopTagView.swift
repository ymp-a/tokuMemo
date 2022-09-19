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
    @State static var categoryName = "カテゴリー"
    @State static var shopName = "ショップ"

    static var previews: some View {
        CategoryShopTagView(categoryName: $categoryName, shopName: $shopName)
    }
}
