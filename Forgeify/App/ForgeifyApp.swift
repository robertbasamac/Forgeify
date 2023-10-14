//
//  ForgeifyApp.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.09.2023.
//

import SwiftUI
import SwiftData

@main
struct ForgeifyApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Workout.self, WorkoutExercise.self], isAutosaveEnabled: false)
    }
}
