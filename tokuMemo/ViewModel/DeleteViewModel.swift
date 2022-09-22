//
//  DeleteViewModel.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/09/22.
//

import SwiftUI
import CoreData

class DeleteViewModel {

    func deleteCategories(offsets: IndexSet, categories: FetchedResults<Category>, viewContext: NSManagedObjectContext) {
        // レコードの削除
        offsets.map { categories[$0] }.forEach(viewContext.delete)
        // データベース保存
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }// do catchここまで
    } // deleteCategoriesここまで

} // DeleteViewModelここまで
