//
//  PreviewSampleData.swift
//  Forgeify
//
//  Created by Robert Basamac on 14.10.2023.
//

import SwiftData
import SwiftUI

actor PreviewSampleData {

    @MainActor
    static var container: ModelContainer = {
        return try! inMemoryContainer()
    }()

    static var inMemoryContainer: () throws -> ModelContainer = {
        let schema = Schema([Workout.self, WorkoutExercise.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let sampleData: [any PersistentModel] = [
            Workout.previewWorkout, WorkoutExercise.previewExercise
        ]
        Task { @MainActor in
            sampleData.forEach {
                container.mainContext.insert($0)
            }
        }
        return container
    }
    
    static var emptyInMemoryContainer: () throws -> ModelContainer = {
        let schema = Schema([Workout.self, WorkoutExercise.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        
        return container
    }
}
