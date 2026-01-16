//
//  test_liquedApp.swift
//  test liqued
//
//  Created by khaled Bakir on 1/14/26.
//

import SwiftUI
import SwiftData

@main
struct test_liquedApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SavedLocation.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
