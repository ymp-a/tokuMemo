//
//  ShopListView.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/07/13.
//

import SwiftUI

struct ShopListView: View {
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center) {
                    Text("SHOP")
                } // HStackここまで

                List {
                    Text("すべて")
                    Text("スギ薬局中野南台")
                    Text("ドンキホーテ新宿店")
                } // Listここまで
                .foregroundColor(.orange)

                Button(action: {
                    // 閉じる処理
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
                    }) {
                        // 追加Viewへ遷移する
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .background(Color.orange)
                            .clipShape(Circle())
                    }
                    Text("SHOP追加")
                        .font(.system(size: 8))
                        .foregroundColor(Color.orange)
                    Spacer()
                } // VStackここまで
            } // HStackここまで
        } // ZStackここまで
    } // bodyここまで
} // CategoryListViewここまで

struct ShopListView_Previews: PreviewProvider {
    static var previews: some View {
        ShopListView()
    }
}
