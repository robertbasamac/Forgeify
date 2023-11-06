//
//  ExerciseSet.swift
//  Forgeify
//
//  Created by Robert Basamac on 28.09.2023.
//

import Foundation
import SwiftData

@Model
final class ExerciseSet {
    var id: UUID
    @Relationship var exercise: Exercise?
    @Relationship var workout: Workout?
    var weight: Int
    var reps: Int
    var rest: Int
    
    init(id: UUID = .init(), weight: Int = 0, reps: Int = 0, rest: Int = 60) {
        self.id = id
        self.weight = weight
        self.reps = reps
        self.rest = rest
    }
    
    init(id: UUID = .init(), exercise: Exercise, weight: Int = 0, reps: Int = 0, rest: Int = 60) {
        self.id = id
        self.exercise = exercise
        self.weight = weight
        self.reps = reps
        self.rest = rest
    }
}

// MARK: - Preview data
extension ExerciseSet {
    static var previewSet: ExerciseSet {
        ExerciseSet(exercise: Exercise.previewExercise, weight: 10, reps: 12, rest: 60)
    }
    
    static var previewSets: [ExerciseSet] {
        [
            ExerciseSet(exercise: Exercise.previewExercises[0], weight: 10, reps: 12, rest: 60),
            ExerciseSet(exercise: Exercise.previewExercises[1], weight: 15, reps: 10, rest: 60),
            ExerciseSet(exercise: Exercise.previewExercises[2], weight: 20, reps: 8, rest: 60)
        ]
    }
}

struct ExerciseSetInfo {
    let exercise: Exercise
    var sets: [ExerciseSet]
}
