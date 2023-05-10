//
//  Armed_watchOSApp.swift
//  Armed watchOS Watch App
//
//  Created by Aayush Pokharel on 2023-05-01.
//

import SwiftUI

@main
struct Armed_watchOSApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
