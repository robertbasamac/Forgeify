//
//  UpdateExerciseSetsView.swift
//  Forgeify
//
//  Created by Robert Basamac on 01.11.2023.
//

import SwiftUI
import SwiftData

struct UpdateExerciseSetsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private var exercise: Exercise
    @State private var exerciseSets: [ExerciseSet]
    
    @State private var title: String = ""
    @State private var selectedSet: ExerciseSet?
    
    private var onAdd: ([ExerciseSet]) -> Void
    
    init(exercise: Exercise, exerciseSets: [ExerciseSet], completion: @escaping ([ExerciseSet]) -> Void) {
        self.exercise = exercise
        self._exerciseSets = State(initialValue: exerciseSets)
        self.onAdd = completion
    }
    
    var body: some View {
        Form {
            titleSection()
            
            setsSection()
            
            addButton()
        }
        .navigationTitle("Edit Exercise")
        .toolbar {
            toolbarItems()
        }
        .sheet(item: $selectedSet) { exerciseSet in
            NavigationStack {
                AddSetView(exerciseSet: exerciseSet) { exerciseSet in
                    handleAdding(of: exerciseSet)
                }
                .navigationTitle(sheetNavigationTitle(exerciseSet: exerciseSet))
            }
            .presentationDetents([.medium])
            .presentationCornerRadius(25)
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Helper Methods
extension UpdateExerciseSetsView {
    private func indexedExerciseSets() -> [(Int, ExerciseSet)] {
        exerciseSets.enumerated().map { ($0 + 1, $1) }
    }
    
    private func sheetNavigationTitle(exerciseSet: ExerciseSet) -> String {
        return exerciseSets.contains(where: { $0.id == exerciseSet.id }) ? "Edit Set" : "Add Set"
    }
    
    private func handleAdding(of exerciseSet: ExerciseSet) {
        if !exerciseSets.contains(where: { $0.id == exerciseSet.id }) {
            exerciseSet.exercise = exercise
            exerciseSets.append(exerciseSet)
        }
    }
    
    private func updateExercise() {
        if !title.isEmpty {
            exercise.title = title
            save()
        }
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving context.")
        }
    }
}

// MARK: - Components
extension UpdateExerciseSetsView {
    @ViewBuilder
    private func titleSection() -> some View {
        Section {
            TextField(exercise.title.isEmpty ? "Enter title here…" : exercise.title, text: $title)
                .textInputAutocapitalization(.words)
        } header: {
            Text("Exercise Title")
        } footer: {
            Text("Note: this title will be updated in all workouts that include this exercise.")
        }
    }
    
    @ViewBuilder
    private func setsSection() -> some View {
        Section {
            ForEach(indexedExerciseSets(), id: \.1.id) { (index, exerciseSet) in
                HStack {
                    Text("\(index)")
                    Spacer()
                    Text("\(exerciseSet.reps) x \(exerciseSet.weight) Kgs")
                    Spacer()
                    Text("\(exerciseSet.rest) s")
                    
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .fontWeight(.semibold)
                        .foregroundStyle(.tertiary)
                }
                .contentShape(.rect)
                .onTapGesture {
                    selectedSet = exerciseSet
                }
            }
            .listRowInsets(.init(top: 0, leading: 30, bottom: 0, trailing: 30))
        } header: {
            Text("Sets")
        }
    }
    
    @ViewBuilder
    private func addButton() -> some View {
        Button {
            let newSet = ExerciseSet()
            selectedSet = newSet
        } label: {
            Label("Add Set", systemImage: "plus")
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button {
                updateExercise()
                onAdd(exerciseSets)

                dismiss()
            } label: {
                Text("Done")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            UpdateExerciseSetsView(exercise: Exercise.previewExercise, exerciseSets: ExerciseSet.previewSets) { _ in }
        }
    }
}
