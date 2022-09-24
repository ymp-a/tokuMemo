//
//  DeleteViewModel.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/09/22.
//

import SwiftUI
import CoreData

class DeleteViewModel {
    // generics<ジェネリック名：型指定>　optionクリック or 選択右クリックJump to Definition:プロトコルチェック
    // Item,Category,Shopに再利用可能な削除機能
    func deleteResult<Result: NSManagedObject>(offsets: IndexSet, result: FetchedResults<Result>, viewContext: NSManagedObjectContext) {
        // レコードの削除
        offsets.map { result[$0] }.forEach(viewContext.delete)
        // データベース保存
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }// do catchここまで
    } // deleteItemsここまで
} // DeleteViewModelここまで
