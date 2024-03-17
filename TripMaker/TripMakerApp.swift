//
//  TripMakerApp.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-16.
//

import SwiftUI

@main
struct TripMakerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
