//
//  Exercise.swift
//  Forgeify
//
//  Created by Robert Basamac on 28.09.2023.
//

import Foundation
import SwiftData

@Model
final class Exercise {
    @Attribute(.unique) var id: UUID
    var title: String
    
    @Relationship(deleteRule: .cascade, inverse: \ExerciseSet.exercise)
    var exerciseSets: [ExerciseSet] = [ExerciseSet]()
    
    init(id: UUID = .init(), title: String, sets: [ExerciseSet] = []) {
        self.id = id
        self.title = title
        self.exerciseSets = sets
    }
}

extension Exercise: Hashable { }

// MARK: - Preview data
extension Exercise {
    static var previewExercise: Exercise {
        Exercise(title: "Leg press")
    }
    
    static var previewExercises: [Exercise] {
        [
            Exercise(title: "Bench press"),
            Exercise(title: "Overhead Shoulder press"),
            Exercise(title: "Push-ups"),
        ]
    }
}
