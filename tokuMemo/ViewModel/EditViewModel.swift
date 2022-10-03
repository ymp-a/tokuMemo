//
//  EditViewModel.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/09/25.
//

import SwiftUI
import CoreData

class EditViewModel {
    // viewContext保存に利用、editCategory:行データ、context：変更したテキスト
    func editResult(viewContext: NSManagedObjectContext, editCategory: Category?, context: String) {
        editCategory!.name = context
        editCategory!.memo = ""
        editCategory!.timestamp = Date()
        // データベース保存
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        } // do catchここまで
    } // editResultここまで

    // 同じ関数名でも引数が異なるので利用できる
    func editResult(viewContext: NSManagedObjectContext, editShop: Shop?, context: String) {
        editShop!.name = context
        editShop!.memo = ""
        editShop!.timestamp = Date()
        // データベース保存
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        } // do catchここまで
    } // editResultここまで
} // EditViewModelここまで
