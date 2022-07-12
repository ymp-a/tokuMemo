//
//  CategoryListView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/07/09.
//

import SwiftUI

struct CategoryListView: View {
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center) {
                    Text("カテゴリー（大分類）")
                } // HStackここまで

                Divider()
                    .background(Color.black)

                List {
                    Text("すべて")
                    Text("日用品")
                    Text("食品")

                } // Listここまで
                .foregroundColor(.orange)

                Divider()
                    .background(Color.black)
                HStack {
                    VStack {
                        Image(systemName: "house")
                            .font(.system(size: 30))
                        Text("Top")
                            .font(.system(size: 12))
                    } // VStackここまで
                    .foregroundColor(.brown)
                    .padding(.horizontal)

                    VStack {
                        Image(systemName: "cart")
                            .font(.system(size: 30))
                            .padding(.horizontal)
                        Text("買い物リスト")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.gray)
                    Spacer()
                } // HStackここまで
            } // VStackここまで

            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        // タップで画面表示させる
                    }, label: {
                        // 追加Viewへ遷移する
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .clipShape(Circle())
                    })
                    Text("カテゴリ追加")
                        .font(.system(size: 8))
                        .foregroundColor(Color.orange)
                    Spacer()
                } // VStackここまで
            } //HStackここまで
        } // ZStackここまで
    } // bodyここまで
} // CategoryListViewここまで

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView()
    }
}
