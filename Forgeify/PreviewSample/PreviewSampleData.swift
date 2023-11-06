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
    
    @MainActor
    static var emptyContainer: ModelContainer = {
        return try! emptyInMemoryContainer()
    }()

    static var inMemoryContainer: () throws -> ModelContainer = {
        let schema = Schema([Exercise.self, Workout.self, ExerciseSet.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        
        var sampleData: [any PersistentModel] {
            var samples: [any PersistentModel] = []
            
            samples.append(contentsOf: Workout.previewWorkouts)
            
            return samples
        }
        
        Task { @MainActor in
            sampleData.forEach {
                container.mainContext.insert($0)
            }
        }
        
        return container
    }
    
    static var emptyInMemoryContainer: () throws -> ModelContainer = {
        let schema = Schema([Exercise.self, Workout.self, ExerciseSet.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        
        return container
    }
}
