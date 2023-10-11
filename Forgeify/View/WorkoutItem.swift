//
//  WorkoutItem.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.09.2023.
//

import SwiftUI

struct WorkoutItem: View {
    private var workout: Workout
    
    init(workout: Workout) {
        self.workout = workout
    }
    
    var body: some View {
        NavigationLink(value: workout) {
            VStack(alignment: .leading) {
                Text(workout.title)
                    .font(.title3.bold())
                Divider()
                Text(workout.subtitle())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .italic()
            }
        }
    }
}

#Preview {
    NavigationStack {
        List {
            WorkoutItem(workout: Workout.previewWorkout)
        }
    }
}
