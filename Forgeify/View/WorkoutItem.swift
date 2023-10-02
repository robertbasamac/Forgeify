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
        self.exerciseTitles = self.workout.subtitle()
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
}

#Preview {
    NavigationStack {
        List {
            WorkoutItem(workout: Workout(title: "Push-ups", exercises: []))
        }
    }
}
