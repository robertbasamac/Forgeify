//
//  Workout.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.09.2023.
//

import Foundation

struct Workout: Identifiable {
    var id: UUID
    var title: String
    var exercises: [Exercise]
    var finished: Bool
    
    init(id: UUID = .init(), title: String, exercises: [Exercise], finished: Bool = false) {
        self.id = id
        self.title = title
        self.exercises = exercises
        self.finished = finished
    }
}

extension Workout: Hashable {
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

extension Workout {
    static var previewWorkouts: [Workout] {
        [
            Workout(title: "Push day",
                    exercises: [
                        Exercise(title: "Bench Press"),
                        Exercise(title: "Push-ups"),
                        Exercise(title: "Cable Flies")
                    ]),
            Workout(title: "Pull day",
                    exercises: [
                        Exercise(title: "Pull-ups"),
                        Exercise(title: "Seated Rows"),
                        Exercise(title: "Biceps Curls")
                    ]),
            Workout(title: "Legs day",
                    exercises: [
                        Exercise(title: "Squats"),
                        Exercise(title: "Front Squats"),
                        Exercise(title: "Single Leg Bulgarian Split Squat")
                    ])
        ]
    }
    
    static var previewWorkout: Workout {
        Workout(title: "Legs day",
                exercises: [
                    Exercise(title: "Squats"),
                    Exercise(title: "Front Squats"),
                    Exercise(title: "Single Leg Bulgarian Split Squat")
                ])
    }
}
