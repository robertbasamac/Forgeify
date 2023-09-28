//
//  Exercise.swift
//  Forgeify
//
//  Created by Robert Basamac on 28.09.2023.
//

import Foundation

struct Exercise: Identifiable {
    var id: UUID
    var title: String
    
    init(id: UUID = .init(), title: String) {
        self.id = id
        self.title = title
    }
}

extension Exercise: Hashable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.title == rhs.title
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

extension Exercise {
    static var previewExercises: [Exercise] {
        [
            Exercise(title: "Bench press"),
            Exercise(title: "Overhead Shoulder press"),
            Exercise(title: "Push-ups")
        ]
    }
    
    static var previewExercise: Exercise {
        Exercise(title: "Bench press")
    }
}
