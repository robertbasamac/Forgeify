//
//  WorkoutManager.swift
//  Forgeify
//
//  Created by Robert Basamac on 28.09.2023.
//

import Foundation

class WorkoutManager: ObservableObject {
    @Published var workouts: [Workout] = Workout.previewWorkouts
    
    static var preview: WorkoutManager = WorkoutManager()
}
