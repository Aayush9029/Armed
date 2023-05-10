//
//  Armed_iOSApp.swift
//  Armed iOS
//
//  Created by Aayush Pokharel on 2023-04-17.
//

import SwiftUI

@main
struct Armed_iOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
