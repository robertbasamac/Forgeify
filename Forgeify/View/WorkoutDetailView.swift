//
//  DetailedWorkoutView.swift
//  Forgeify
//
//  Created by Robert Basamac on 12.10.2023.
//

import SwiftUI

struct WorkoutDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    private var workout: Workout

    init(workout: Workout) {
        self.workout = workout
    }
    
    var body: some View {
        Form {
            ForEach(workout.exercises) { exercise in
                Text(exercise.title)
            }
            .onMove(perform: { indices, newOffset in
                workout.exercises.move(fromOffsets: indices, toOffset: newOffset)
                
                do {
                    try modelContext.save()
                } catch {
                    print("Error saving the context.")
                }
            })
        }
        .navigationTitle(workout.title)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                EditButton()
            }
        }
    }
}

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        WorkoutDetailView(workout: .previewWorkout)
    }
}
