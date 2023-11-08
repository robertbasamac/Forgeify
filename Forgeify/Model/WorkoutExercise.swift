//
//  WorkoutExercise.swift
//  Forgeify
//
//  Created by Robert Basamac on 17.10.2023.
//

import Foundation
import SwiftData

@Model
final class WorkoutExercise {
    var id: UUID
    var exercise: Exercise?
    var workout: Workout?
    var sets: [ExerciseSet] = [ExerciseSet]()
    var index: Int
    
    init(id: UUID = .init(), sets: [ExerciseSet] = [], index: Int = -1) {
        self.id = id
        self.sets = sets
        self.index = index
    }
    
    init(id: UUID = .init(), exercise: Exercise, sets: [ExerciseSet] = [], index: Int = -1) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
        self.index = index
    }
}

extension WorkoutExercise {
    @Transient
    var title: String {
        exercise?.title ?? "Empty"
    }
}

// MARK: - Preview data
extension WorkoutExercise {
    static var previewExercise: WorkoutExercise {
        WorkoutExercise(exercise: Exercise.previewExercise,
                        sets: ExerciseSet.previewSets)
    }
    
    static var previewExercises: [WorkoutExercise] {
        var exercises: [WorkoutExercise] = []
        
        for exercise in Exercise.previewExercises {
            let exerciseToAdd = WorkoutExercise(exercise: exercise,
                                                sets: ExerciseSet.previewSets)
            exercises.append(exerciseToAdd)
        }
        
        return exercises
    }
}
