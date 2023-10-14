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
    var title: String
    
    @Relationship(deleteRule: .nullify, inverse: \WorkoutExercise.workouts)
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
                exercises: [
                    WorkoutExercise(title: "Squats",
                             sets: [
                                ExerciseSet(weight: 10, reps: 12, rest: 60),
                                ExerciseSet(weight: 15, reps: 10, rest: 60),
                                ExerciseSet(weight: 20, reps: 8, rest: 60)
                             ]),
                    WorkoutExercise(title: "Front Squats",
                             sets: [
                                ExerciseSet(weight: 10, reps: 12, rest: 60),
                                ExerciseSet(weight: 15, reps: 10, rest: 60),
                                ExerciseSet(weight: 20, reps: 8, rest: 60)
                             ]),
                    WorkoutExercise(title: "Single Leg Bulgarian Split Squat",
                             sets: [
                                ExerciseSet(weight: 10, reps: 12, rest: 60),
                                ExerciseSet(weight: 15, reps: 10, rest: 60),
                                ExerciseSet(weight: 20, reps: 8, rest: 60)
                             ])
                ])
    }
    
    static var previewWorkouts: [Workout] {
        [
            Workout(title: "Push day",
                    exercises: [
                        WorkoutExercise(title: "Bench Press",
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
                                 ]),
                        WorkoutExercise(title: "Cable Flies",
                                 sets: [
                                    ExerciseSet(weight: 10, reps: 12, rest: 60),
                                    ExerciseSet(weight: 15, reps: 10, rest: 60),
                                    ExerciseSet(weight: 20, reps: 8, rest: 60)
                                 ])
                    ]),
            Workout(title: "Pull day",
                    exercises: [
                        WorkoutExercise(title: "Pull-ups",
                                 sets: [
                                    ExerciseSet(weight: 10, reps: 12, rest: 60),
                                    ExerciseSet(weight: 15, reps: 10, rest: 60),
                                    ExerciseSet(weight: 20, reps: 8, rest: 60)
                                 ]),
                        WorkoutExercise(title: "Seated Rows",
                                 sets: [
                                    ExerciseSet(weight: 10, reps: 12, rest: 60),
                                    ExerciseSet(weight: 15, reps: 10, rest: 60),
                                    ExerciseSet(weight: 20, reps: 8, rest: 60)
                                 ]),
                        WorkoutExercise(title: "Biceps Curls",
                                 sets: [
                                    ExerciseSet(weight: 10, reps: 12, rest: 60),
                                    ExerciseSet(weight: 15, reps: 10, rest: 60),
                                    ExerciseSet(weight: 20, reps: 8, rest: 60)
                                 ])
                    ]),
            Workout(title: "Legs day",
                    exercises: [
                        WorkoutExercise(title: "Squats",
                                 sets: [
                                    ExerciseSet(weight: 10, reps: 12, rest: 60),
                                    ExerciseSet(weight: 15, reps: 10, rest: 60),
                                    ExerciseSet(weight: 20, reps: 8, rest: 60)
                                 ]),
                        WorkoutExercise(title: "Front Squats",
                                 sets: [
                                    ExerciseSet(weight: 10, reps: 12, rest: 60),
                                    ExerciseSet(weight: 15, reps: 10, rest: 60),
                                    ExerciseSet(weight: 20, reps: 8, rest: 60)
                                 ]),
                        WorkoutExercise(title: "Single Leg Bulgarian Split Squat",
                                 sets: [
                                    ExerciseSet(weight: 10, reps: 12, rest: 60),
                                    ExerciseSet(weight: 15, reps: 10, rest: 60),
                                    ExerciseSet(weight: 20, reps: 8, rest: 60)
                                 ])
                    ])
        ]
    }
}
