//
//  WorkoutListItem.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.09.2023.
//

import SwiftUI
import SwiftData
import Observation

@Observable
class WorkoutModel {
    var workout: Workout

    init(workout: Workout) {
        self.workout = workout
    }
}

struct WorkoutListItem: View {
    @Environment(\.modelContext) private var modelContext
    
    private var workout: WorkoutModel
    
    init(workout: Workout) {
        self.workout = WorkoutModel(workout: workout)
    }
    
    var body: some View {
        NavigationLink {
            Text(workout.workout.title)
        } label: {
            VStack(alignment: .leading) {
                Text(workout.workout.title)
                    .font(.title3.bold())
                Divider()
                Text(workout.workout.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .italic()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            List {
                WorkoutListItem(workout: Workout.previewWorkout)
            }
        }
    }
}
