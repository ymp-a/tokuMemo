//
//  Persistence.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/06/27.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Category.entity()の中身を取得している？
        let fetchRequestCategories = NSFetchRequest<NSFetchRequestResult>()
        fetchRequestCategories.entity = Category.entity()

        // Shop.entity()の中身を取得している？
        let fetchRequestShops = NSFetchRequest<NSFetchRequestResult>()
        fetchRequestShops.entity = Shop.entity()

        // Item.entity()の中身を取得している？
        let fetchRequestItems = NSFetchRequest<NSFetchRequestResult>()
        fetchRequestItems.entity = Item.entity()

        // サンプルデータの代入
        let newCategory = Category(context: viewContext)
        newCategory.name = "すべて"
        newCategory.memo = ""
        newCategory.timestamp = Date()

        let newShop = Shop(context: viewContext)
        newShop.name = "すべて"
        newShop.memo = ""
        newShop.timestamp = Date()

        let newItem = Item(context: viewContext)
        newItem.itemName = "いろはす"
        newItem.categoryName = "すべて"
        newItem.shopName = "すべて"
        newItem.price = 85
        newItem.discountPrice = 0
        newItem.volume = 1000
        newItem.qtyunit = 2
        newItem.memo = ""
        newItem.timestamp = Date()
        // リレーション関係
        newItem.category = newCategory
        newItem.shop = newShop

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "tokuMemo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
