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
    func deleteResult(viewContext: NSManagedObjectContext, editCategory: Category?) {
        // 削除する1行分の情報
        viewContext.delete(editCategory!)
        // データベース保存
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }// do catchここまで
    } // deleteResultここまで

    func deleteResult2(viewContext: NSManagedObjectContext, editShop: Shop?) {
        // 削除する1行分の情報
        viewContext.delete(editShop!)
        // データベース保存
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }// do catchここまで
    } // deleteItems2ここまで
} // DeleteViewModelここまで
