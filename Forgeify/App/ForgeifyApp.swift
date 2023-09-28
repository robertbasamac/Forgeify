//
//  ForgeifyApp.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.09.2023.
//

import SwiftUI

@main
struct ForgeifyApp: App {
    @StateObject private var workoutManager: WorkoutManager = WorkoutManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutManager)
        }
    }
}
