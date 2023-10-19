//
//  ExerciseSelectionView.swift
//  Forgeify
//
//  Created by Robert Basamac on 02.10.2023.
//

import SwiftUI
import SwiftData

struct ExerciseSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Exercise.title) private var exercises: [Exercise]
    
    @Binding private var selections: [WorkoutExercise]
    @State private var showAddExercise: Bool = false
        
    init(selections: Binding<[WorkoutExercise]>) {
        self._selections = Binding(projectedValue: selections)
    }
    
    var body: some View {
        List {
            ForEach(exercises){ exercise in
                HStack {
                    Image(systemName: getItemCheckmark(for: exercise))
                    Text(exercise.title)
                }
                .onTapGesture {
                    handleSelection(of: exercise)
                }
            }
            .onDelete(perform: deleteExercises)
        }
        .navigationTitle("Add Exercises")
        .scrollDisabled(exercises.isEmpty)
        .overlay {
            emptyExercisesView()
        }
        .toolbar {
            toolbarItems()
        }
        .navigationDestination(isPresented: $showAddExercise) {
            AddExerciseView() { exercise in
                let workoutExercise = WorkoutExercise(exercise: exercise)
                exercise.exercises.append(workoutExercise)
                
                selections.append(workoutExercise)
            }
        }
    }
    
    private func handleSelection(of exercise: Exercise) {
        if selections.contains(where: { $0.id == exercise.id }) {
            selections.removeAll { $0.exercise == exercise }
        } else {
            let workoutExercise = WorkoutExercise(exercise: exercise)
            selections.append(workoutExercise)
        }
    }
    
    private func getItemCheckmark(for exercise: Exercise) -> String {
        return selections.contains(where: { $0.exercise == exercise }) ? "checkmark.circle.fill" : "circle"
    }
    
    private func deleteExercises(at offsets: IndexSet) {
        withAnimation {
            offsets.map { exercises[$0] }.forEach { exercise in
                selections.removeAll { $0.id == exercise.id }
                deleteExercise(exercise)
            }
        }
    }
    
    private func deleteExercise(_ exercise: Exercise) {
        modelContext.delete(exercise)
        save()
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
extension ExerciseSelectionView {
    @ViewBuilder
    private func emptyExercisesView() -> some View {
        if exercises.isEmpty {
            ContentUnavailableView {
                Label("No Exercise in your collection.", systemImage: "figure.run.circle")
            } description: {
                Text("New exercises you create will appear here.\nTap the button below to create a new exercise.")
            } actions: {
                Button {
                    showAddExercise.toggle()
                } label: {
                    Text("Add Exercise")
                        .padding(4)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showAddExercise.toggle()
            } label: {
                Label("Create new Exercise", systemImage: "plus")
            }
        }
    }
}


// MARK: - Previews
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            ExerciseSelectionView(selections: .constant([]))
        }
    }
}

#Preview {
    ModelContainerPreview(PreviewSampleData.emptyInMemoryContainer) {
        NavigationStack {
            ExerciseSelectionView(selections: .constant([]))
        }
    }
}
