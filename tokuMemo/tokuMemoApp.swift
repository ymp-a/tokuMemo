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

    var body: some Scene {
        WindowGroup {
            TokuMemoListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
