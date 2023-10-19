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
    @Attribute(.unique) var title: String
    
    @Relationship(deleteRule: .cascade, inverse: \WorkoutExercise.exercise)
    var exercises: [WorkoutExercise] = [WorkoutExercise]()
    
    init(id: UUID = .init(), title: String = "", exercises: [WorkoutExercise] = []) {
        self.id = id
        self.title = title
        self.exercises = exercises
    }
}

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
