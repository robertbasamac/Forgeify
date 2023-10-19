//
//  Workout.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.09.2023.
//

import Foundation
import SwiftData

@Model
final class Workout {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var title: String
    
    @Relationship(deleteRule: .cascade, inverse: \WorkoutExercise.workout)
    var exercises: [WorkoutExercise] = [WorkoutExercise]()
    
    init(id: UUID = .init(), title: String = "", exercises: [WorkoutExercise] = []) {
        self.id = id
        self.title = title
        self.exercises = exercises
    }
}

extension Workout {
    @Transient
    var subtitle: String {
        let exerciseTitles = self.exercises
            .compactMap { $0.title.lowercased() }
            .joined(separator: ", ")
        
        return exercises.isEmpty ? "No exercises" : exerciseTitles
    }
}

// MARK: - Preview data
extension Workout {
    static var previewWorkout: Workout {
        Workout(title: "Legs day",
                exercises: [WorkoutExercise.previewExercise])
    }
    
    static var previewWorkouts: [Workout] {
        [
            Workout(title: "Legs day",
                    exercises: [WorkoutExercise.previewExercise]),
            Workout(title: "Push day",
                    exercises: WorkoutExercise.previewExercises)
        ]
    }
}
