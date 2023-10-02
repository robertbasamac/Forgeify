//
//  Exercise.swift
//  Forgeify
//
//  Created by Robert Basamac on 28.09.2023.
//

import Foundation
import SwiftData

@Model
final class WorkoutExercise: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var sets: [ExerciseSet]
    
    init(id: UUID = .init(), title: String = "", sets: [ExerciseSet] = []) {
        self.id = id
        self.title = title
        self.sets = sets
    }
}

// MARK: - Hashable
extension WorkoutExercise: Hashable {
    static func == (lhs: WorkoutExercise, rhs: WorkoutExercise) -> Bool {
        lhs.title == rhs.title && lhs.sets == rhs.sets
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(sets)
    }
}

// MARK: - Preview data
extension WorkoutExercise {
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
    
    static var previewExercise: WorkoutExercise {
        WorkoutExercise(title: "Bench press",
                 sets: [
                    ExerciseSet(weight: 10, reps: 12, rest: 60),
                    ExerciseSet(weight: 15, reps: 10, rest: 60),
                    ExerciseSet(weight: 20, reps: 8, rest: 60)
                 ])
    }
}