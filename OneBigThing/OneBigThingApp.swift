//
//  OneBigThingApp.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 29/04/2025.
//

import SwiftUI
import SwiftData

@main
struct OneBigThingApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Thing.self,
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
                .onAppear {
                                    NotificationHelper.requestPermissionAndSchedule()
                                }
        }
        .modelContainer(sharedModelContainer)
    }
}
