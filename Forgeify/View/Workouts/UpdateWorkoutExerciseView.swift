//
//  UpdateWorkoutExerciseView.swift
//  Forgeify
//
//  Created by Robert Basamac on 19.10.2023.
//

import SwiftUI
import SwiftData

struct UpdateWorkoutExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private var exercise: WorkoutExercise
    
    @State private var title: String = ""
    @State private var exerciseSets: [ExerciseSet] = []
    @State private var selectedSet: ExerciseSet?
    
//    @State private var showAddSet: Bool = false
    
    init(exercise: WorkoutExercise) {
        self.exercise = exercise
        self._exerciseSets = State(initialValue: exercise.sets)
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
            .interactiveDismissDisabled()
        }
    }
}

// MARK: - Helper methods
extension UpdateWorkoutExerciseView {
    private func sheetNavigationTitle(exerciseSet: ExerciseSet) -> String {
        return exerciseSets.contains(where: { $0.id == exerciseSet.id }) ? "Edit Set" : "Add Set"
    }
    
    private func indexedExerciseSets() -> [(Int, ExerciseSet)] {
        exerciseSets.enumerated().map { ($0 + 1, $1) }
    }
    
    private func handleAdding(of exerciseSet: ExerciseSet) {
        if !exerciseSets.contains(where: { $0.id == exerciseSet.id }) {
            exerciseSets.append(exerciseSet)
        } else {
            guard let index = exerciseSets.firstIndex(where: { $0.id == exerciseSet.id } ) else { return }
            exerciseSets[index] = exerciseSet
        }
    }
    
    private func update() {
        guard let exerciseToEdit = exercise.exercise else { return }
        
        if !title.isEmpty {
            exerciseToEdit.title = title
        }
        
        exercise.sets = exerciseSets
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving context.")
        }
    }
    
    private func delete(at offsets: IndexSet) {
        withAnimation {
            exerciseSets.remove(atOffsets: offsets)
        }
    }

    private func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        withAnimation {
            exerciseSets.move(fromOffsets: source, toOffset: destination)
        }
    }
}

// MARK: - Components
extension UpdateWorkoutExerciseView {
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
        if !exerciseSets.isEmpty {
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
                .onDelete(perform: delete)
                .onMove(perform: move)
                .listRowInsets(.init(top: 0, leading: 30, bottom: 0, trailing: 30))
            } header: {
                Text("Sets")
            }
        }
    }
    
    @ViewBuilder
    private func setsSection2() -> some View {
        if !exerciseSets.isEmpty {
            Section {
                ForEach(exerciseSets) { exerciseSet in
                    HStack {
                        Text("Weight: \(exerciseSet.weight)")
                        Text("Reps: \(exerciseSet.reps)")
                        Text("Rest: \(exerciseSet.rest)")
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }  header: {
                Text("Sets")
            }
        }
    }
    
    @ViewBuilder
    private func addButton() -> some View {
        Button {
            let newSet = ExerciseSet()
            selectedSet = newSet
            //            showAddSet.toggle()
        } label: {
            Label("Add Set", systemImage: "plus")
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button {
                update()
                
                dismiss()
            } label: {
                Text("Save")
            }
            .disabled(isSaveButtonDisabled())
        }
    }
    
    private func isSaveButtonDisabled() -> Bool {
        return title.isEmpty && exercise.sets == exerciseSets
    }
}
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            UpdateWorkoutExerciseView(exercise: WorkoutExercise.previewExercise)
        }
    }
}
