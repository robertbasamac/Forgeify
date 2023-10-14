//
//  Exercise.swift
//  Forgeify
//
//  Created by Robert Basamac on 28.09.2023.
//

import Foundation
import SwiftData

@Model
final class WorkoutExercise {
    @Attribute(.unique) var id: UUID
    var title: String
    var sets: [ExerciseSet]
    var workouts: [Workout] = [Workout]()
    
    init(id: UUID = .init(), title: String = "", sets: [ExerciseSet] = []) {
        self.id = id
        self.title = title
        self.sets = sets
    }
}

// MARK: - Preview data
extension WorkoutExercise {
    static var previewExercise: WorkoutExercise {
        WorkoutExercise(title: "Overhead Shoulder press",
                 sets: [
                    ExerciseSet(weight: 10, reps: 12, rest: 60),
                    ExerciseSet(weight: 15, reps: 10, rest: 60),
                    ExerciseSet(weight: 20, reps: 8, rest: 60)
                 ])
    }
    
    static var previewExercises: [WorkoutExercise] {
        [
            WorkoutExercise(title: "Bench press",
                     sets: [
                        ExerciseSet(weight: 10, reps: 12, rest: 60),
                        ExerciseSet(weight: 15, reps: 10, rest: 60),
                        ExerciseSet(weight: 20, reps: 8, rest: 60),
                     ]),
            WorkoutExercise(title: "Overhead Shoulder press",
                     sets: [
                        ExerciseSet(weight: 10, reps: 12, rest: 60),
                        ExerciseSet(weight: 15, reps: 10, rest: 60),
                        ExerciseSet(weight: 20, reps: 8, rest: 60)
                     ]),
            WorkoutExercise(title: "Push-ups",
                     sets: [
                        ExerciseSet(weight: 10, reps: 12, rest: 60),
                        ExerciseSet(weight: 15, reps: 10, rest: 60),
                        ExerciseSet(weight: 20, reps: 8, rest: 60)
                     ])
        ]
    }
}
