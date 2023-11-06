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
    
    @Relationship(deleteRule: .cascade, inverse: \ExerciseSet.workout)
    var exercises: [ExerciseSet] = [ExerciseSet]()
    
    init(id: UUID = .init(), title: String, exercises: [ExerciseSet] = []) {
        self.id = id
        self.title = title
        self.exercises = exercises
    }
}

extension Workout {
    @Transient
    var subtitle: String {
        let uniqueExerciseTitles = Set(self.exercises.compactMap { $0.exercise?.title.lowercased() })
        let exerciseTitles = uniqueExerciseTitles.joined(separator: ", ")
        
        return exercises.isEmpty ? "No exercises" : (exerciseTitles.isEmpty ? "Empty" : exerciseTitles)
    }
}

// MARK: - Preview data
extension Workout {
    static var previewWorkout: Workout {
        Workout(title: "Legs day",
                exercises: [ExerciseSet.previewSet])
    }
    
    static var previewWorkouts: [Workout] {
        [
            Workout(title: "Legs day",
                    exercises: [ExerciseSet.previewSet]),
            Workout(title: "Push day",
                    exercises: ExerciseSet.previewSets)
        ]
    }
}
