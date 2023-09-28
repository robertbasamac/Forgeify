//
//  WorkoutItem.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.09.2023.
//

import SwiftUI

struct WorkoutItem: View {
    var workout: Workout
    private var exerciseTitles: String = ""
    
    init(workout: Workout) {
        self.workout = workout
        self.exerciseTitles = getExercisesTitlesString(from: workout)
    }
    var body: some View {
        NavigationLink(value: workout) {
            VStack(alignment: .leading) {
                Text(workout.title)
                    .font(.headline)
                Divider()
                Text(exerciseTitles)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
    }
    
    private func getExercisesTitlesString(from workout: Workout) -> String {
        let exerciseTitles = workout.exercises.map { $0.title.lowercased() }
        return exerciseTitles.joined(separator: ", ")
    }
}

#Preview {
    List {
        WorkoutItem(workout: Workout.previewWorkout)
    }
}
