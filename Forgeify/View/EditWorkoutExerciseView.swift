//
//  EditWorkoutExerciseView.swift
//  Forgeify
//
//  Created by Robert Basamac on 19.10.2023.
//

import SwiftUI
import SwiftData

struct EditWorkoutExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var exercise: WorkoutExercise
    
    @State private var title: String = ""
    @State private var sets: [ExerciseSet] = []
    
    @State private var showAddSet: Bool = false
    
    init(exercise: WorkoutExercise) {
        self.exercise = exercise
        self._sets = State(initialValue: exercise.sets)
    }
    
    var body: some View {
        Form {
            Section {
                TextField(exercise.title.isEmpty ? "Enter title here..." : exercise.title, text: $title)
            } header: {
                Text("Exercise Title")
            } footer: {
                Text("This title will be updated in all workouts that include this exercise.")
            }
            
            if !sets.isEmpty {
                Section {
                    ForEach(sets) { set in
                        HStack {
                            Text("Weight: \(set.weight)")
                            Text("Reps: \(set.reps)")
                            Text("Rest: \(set.rest)")
                        }
                    }
                } header: {
                    Text("Sets")
                }
            }
            
            addButton()
        }
        .navigationTitle("Edit Exercise")
        .toolbar {
            toolbarItems()
        }
        .sheet(isPresented: $showAddSet) {
            NavigationStack {
                AddExerciseSetView(sets: $sets)
            }
            .presentationDetents([.fraction(0.45)])
            .presentationCornerRadius(20)
            .interactiveDismissDisabled()
        }
    }
}

// MARK: - Helper methods
extension EditWorkoutExerciseView {
    private func update() {
        guard let exerciseToEdit = exercise.exercise else { return }
        
        if !title.isEmpty {
            exerciseToEdit.title = title
        }
        
        exercise.sets = sets
        
        do {
            try modelContext.save()
        } catch {
            print("Error")
        }
    }
    
    private func delete(at offsets: IndexSet) {
        withAnimation {
            sets.remove(atOffsets: offsets)
        }
    }

    private func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        withAnimation {
            sets.move(fromOffsets: source, toOffset: destination)
        }
    }
}

// MARK: - Components
extension EditWorkoutExerciseView {
    @ViewBuilder
    private func setsSection() -> some View {
        if !sets.isEmpty {
            Section {
                ForEach(sets) { set in
                    HStack {
                        Text("Weight: \(set.weight)")
                        Text("Reps: \(set.reps)")
                        Text("Rest: \(set.rest)")
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
            showAddSet.toggle()
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
        return title.isEmpty && exercise.sets == sets
    }
}
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            EditWorkoutExerciseView(exercise: WorkoutExercise.previewExercise)
        }
    }
}
