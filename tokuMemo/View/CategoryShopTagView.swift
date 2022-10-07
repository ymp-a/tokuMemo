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
                ButtonTab(text: categoryName)
            }
            // カテゴリ画面モーダル表示
            .fullScreenCover(isPresented: $showingModalCategoryListView) {
                CategoryListView(categoryName: $categoryName)
            }
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.orange, lineWidth: 3)
            )

            Button(action: {
                // ボタンタップでショップ画面フラグオン
                showingModalShopListView.toggle()
            }) {
                ButtonTab(text: shopName)
            }
            // カテゴリ画面モーダル表示
            .fullScreenCover(isPresented: $showingModalShopListView) {
                ShopListView(shopName: $shopName)
            }
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.orange, lineWidth: 3)
            )
        } // HStackここまで
        .font(.title3)
        .foregroundColor(.orange)
        .padding(.horizontal)
    } // bodyここまで
} // CategoryShopTagViewここまで

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

// struct ButtonTab2 {
//    @State private var flag: Bool
//    private var text: String
//    var listView: ?
//    var body: some View {
//        Button(action: {
//            // ボタンタップでカテゴリ画面フラグオン
//            self.flag.toggle()
//        }) {
//          Text(text)
//              .frame(maxWidth: .infinity)
//              .bold()
//              .lineLimit(1)
//              .minimumScaleFactor(0.1)
//          Image(systemName: "chevron.right.circle")
//              .bold()
//        }
//        // カテゴリ画面モーダル表示
//        .fullScreenCover(isPresented: $flag) {
//            listView
//        }
//        .padding(5)
//        .overlay(
//            RoundedRectangle(cornerRadius: 7)
//                .stroke(Color.orange, lineWidth: 3)
//        )
//    }
// }

//            ButtonTab2(flag: showingModalCategoryListView, text: categoryName,  listView: CategoryListView(categoryName: $categoryName))

struct CategoryShopTagView_Previews: PreviewProvider {
    @State static var categoryName = "カテゴリー"
    @State static var shopName = "ショップ"

    static var previews: some View {
        CategoryShopTagView(categoryName: $categoryName, shopName: $shopName)
    }
}
