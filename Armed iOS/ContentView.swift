//
//  ContentView.swift
//  Armed iOS
//
//  Created by Aayush Pokharel on 2023-04-17.
//

import CoreData
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            CloudPhotosView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CloudPhotosView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
