//
//  TripMakerApp.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-16.
//

import SwiftUI
import SwiftData

@main
struct TripMakerApp: App {
    let dbManager = DBManager.shared
    
    //@State private var modelData = ModelData()
    
    init() {
        do {
            // Debug purpose
            //dbManager.deleteAllData()
            
            //try dbManager.addDummyData()
            dbManager.fetchInfoFromApi()
            //dbManager.inspectAllTables()
        } catch {
            print("An error occurred while initializing dummy data: \(error)")
        }
    }
    
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
               // .environment(modelData)
        }
//        .modelContainer(sharedModelContainer)
    }
}

