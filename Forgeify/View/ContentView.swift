//
//  ContentView.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.10.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection: Tab = .workouts
    
    enum Tab: String, Identifiable {
        var id: Self { self }
        
        case workouts = "Workouts"
        case exercises = "Exercises"
        
        var systemImageName: String {
            switch self {
            case .workouts:
                return "figure.run.square.stack"
            case .exercises:
                return "figure"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationStack {
                WorkoutsTab()
            }
            .tabItem {
                Label(Tab.workouts.rawValue, systemImage: Tab.workouts.systemImageName)
            }
            .tag(Tab.workouts)
            
            NavigationStack {
                ExercisesTab()
            }
            .tabItem {
                Label(Tab.exercises.rawValue, systemImage: Tab.exercises.systemImageName)
            }
            .tag(Tab.exercises)
        }
    }
}

#Preview("Filled") {
    ContentView()
        .modelContainer(PreviewSampleData.container)
}

#Preview("Empty") {
    ContentView()
        .modelContainer(PreviewSampleData.emptyContainer)
}
