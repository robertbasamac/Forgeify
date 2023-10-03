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
    @Query(sort: \WorkoutExercise.title) private var exercises: [WorkoutExercise]
        
    @State private var selections: [WorkoutExercise]
    @State private var showAddExercise: Bool = false
    
    private let onAdd: (Array<WorkoutExercise>) -> Void
    
    init(selections: [WorkoutExercise], onAdd: @escaping (Array<WorkoutExercise>) -> Void) {
        self._selections = State(wrappedValue: selections)
        self.onAdd = onAdd
    }
    
    var body: some View {
        List(exercises) { exercise in
            HStack {
                Image(systemName: getItemCheckmark(for: exercise))
                Text(exercise.title)
            }
            .onTapGesture {
                if selections.contains(where: { $0.id == exercise.id }) {
                    selections.removeAll { $0.id == exercise.id }
                } else {
                    selections.append(exercise)
                }
            }
        }
        .navigationTitle("Add Exercises")
        .scrollDisabled(exercises.isEmpty)
        .overlay {
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
        .toolbar {
            toolbarItems()
        }
        .navigationDestination(isPresented: $showAddExercise) {
            AddExerciseView() { exercise in
                selections.append(exercise)
            }
        }
    }
    
    private func getItemCheckmark(for exercise: WorkoutExercise) -> String {
        return selections.contains(exercise) ? "checkmark.circle.fill" : "circle"
    }
    
    
 }

// MARK: - Components
extension ExerciseSelectionView {
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Button {
                showAddExercise.toggle()
            } label: {
                Label("Create new Exercise", systemImage: "plus")
            }
        }
        
        ToolbarItem(placement: .confirmationAction) {
            Button("Done") {
                onAdd(selections)
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseSelectionView(selections: []) { _ in }
    }
}
