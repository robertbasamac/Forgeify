//
//  WorkoutDetailView.swift
//  Forgeify
//
//  Created by Robert Basamac on 12.10.2023.
//

import SwiftUI
import SwiftData

struct WorkoutDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    
    private var workout: Workout
    @State private var exercises: [WorkoutExercise]
    
    init(workout: Workout) {
        self.workout = workout
        self._exercises = State(initialValue: workout.sortedExercises)
    }
    
    var body: some View {
        Form {
            ForEach(exercises) { exercise in
                ExerciseRowView(exercise: exercise)
            }
            .onMove(perform: move)
            .onChange(of: editMode?.wrappedValue, { _, newValue in
                if newValue?.isEditing == false {
                    workout.exercises = exercises
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

// MARK: - Helper Methods
extension WorkoutDetailView {
    private func sortedExercises() -> [WorkoutExercise] {
        return exercises.sorted { $0.index < $1.index }
    }
    
    private func move(fromOffsets source: IndexSet, toOffsets destination: Int) {
        withAnimation {
            exercises.move(fromOffsets: source, toOffset: destination)
        }
        
        for index in exercises.indices {
            exercises[index].index = index
        }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            WorkoutDetailView(workout: Workout.previewWorkout)
        }
    }
}
