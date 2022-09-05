//
//  tokuMemoApp.swift
//  tokuMemo
//
//  Created by satoshi yamashita on 2022/06/27.
//

import SwiftUI

@main
struct tokuMemoApp: App {
    let persistenceController = PersistenceController.shared

    @State static var categoryText = "すべて"
    var body: some Scene {
        WindowGroup {
            TokuMemoListView(categoryText: tokuMemoApp.$categoryText)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
