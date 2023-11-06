//
//  AddWorkoutView.swift
//  Forgeify
//
//  Created by Robert Basamac on 31.10.2023.
//

import SwiftUI
import SwiftData

struct AddWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
        
    @State private var title: String = ""
    @State private var exerciseSetsInfo: [Exercise: [ExerciseSet]] = [:]

    @State private var showAddExercise: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                titleSection()
                
                exercisesSection()
                
                addButton()
            }
            .navigationBarTitle("Create New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarItems()
            }
            .navigationDestination(isPresented: $showAddExercise) {
                ExerciseSelectionView(exerciseSetInfo: $exerciseSetsInfo)
            }
        }
        .onDisappear {
            for exerciseSets in exerciseSetsInfo.values {
                for exercise in exerciseSets {
                    if exercise.workout == nil {
                        modelContext.delete(exercise)
                    }
                }
            }
        }
    }
}

// MARK: - Helper Methods
extension AddWorkoutView {
    private func addWorkout() {
        let workout = Workout(title: title)
        workout.exercises = exerciseSetsInfo.values.flatMap { $0 }
        modelContext.insert(workout)
        
        save()
    }
    
    private func deleteExercises(at offsets: IndexSet) {
        withAnimation {
            let exercisesToRemove = offsets.map { index in
                Array(exerciseSetsInfo.keys)[index]
            }
            
            for exercise in exercisesToRemove {
                exerciseSetsInfo.removeValue(forKey: exercise)
            }
        }
    }
    
    private func move(fromOffsets source: IndexSet, toOffsets destinationIndex: Int) {
        // to be implemented
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving context.")
        }
    }
    
    private func getExerciseSets(of exercise: Exercise) -> [ExerciseSet] {
        return exerciseSetsInfo[exercise] ?? []
    }
    
    private func isDoneButtonDisabled() -> Bool {
        return title.isEmpty
    }
}

// MARK: - Components
extension AddWorkoutView {
    @ViewBuilder
    private func titleSection() -> some View {
        Section {
            TextField("Enter title here…", text: $title)
                .textInputAutocapitalization(.words)
        } header: {
            Text("Workout Title")
        }
    }
    
    @ViewBuilder
    private func exercisesSection() -> some View {
        if !exerciseSetsInfo.isEmpty {
            Section {
                ForEach(Array(exerciseSetsInfo.keys), id: \.id) { exercise in
                    NavigationLink {
                        UpdateExerciseSetsView(exercise: exercise, exerciseSets: getExerciseSets(of: exercise)) { sets in
                            exerciseSetsInfo[exercise] = sets
                        }
                    } label: {
                        ExerciseRowView(exercise: exercise, sets: getExerciseSets(of: exercise))
                    }
                }
                .onDelete(perform: deleteExercises)
                .onMove(perform: move)
            } header: {
                Text("Exercises")
            }
        }
    }
    
    @ViewBuilder
    private func addButton() -> some View {
        Button {
            showAddExercise = true
        } label: {
            Label("Add exercise", systemImage: "plus")
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            EditButton()
                .disabled(exerciseSetsInfo.isEmpty)
        }
        
        ToolbarItem(placement: .confirmationAction) {
            Button {
                addWorkout()
                
                dismiss()
            } label: {
                Text("Done")
            }
            .disabled(isDoneButtonDisabled())
        }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            AddWorkoutView()
        }
    }
}
