//
//  UpdateSetView.swift
//  Forgeify
//
//  Created by Robert Basamac on 01.11.2023.
//

import SwiftUI

struct AddSetView: View {
    @Environment(\.dismiss) private var dismiss

    private var exerciseSet: ExerciseSet
    private var onDone: (ExerciseSet) -> Void
    
    @State private var reps: Int
    @State private var weight: Int
    @State private var rest: Int
    
    init(exerciseSet: ExerciseSet, completion: @escaping (ExerciseSet) -> Void) {
        self.exerciseSet = exerciseSet
        self._reps = State(initialValue: exerciseSet.reps)
        self._weight = State(initialValue: exerciseSet.weight)
        self._rest = State(initialValue: exerciseSet.rest)
        self.onDone = completion
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Reps", value: $reps, format: .number)
            } header: {
                Text("Reps")
            }
            
            Section {
                TextField("Weight", value: $weight, format: .number)
            } header: {
                Text("Weight")
            }
            
            Section {
                TextField("Rest", value: $rest, format: .number)
            } header: {
                Text("Rest")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarItems()
        }
    }
}

// MARK: - Helper Methods
extension AddSetView {
    private func updateSet() {
        exerciseSet.reps = reps
        exerciseSet.weight = weight
        exerciseSet.rest = rest
    }
}

// MARK: - Components
extension AddSetView {
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button {
                updateSet()
                onDone(exerciseSet)
                
                dismiss()
            } label: {
                Text("Done")
            }
        }
        
        ToolbarItem(placement: .cancellationAction) {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            AddSetView(exerciseSet: ExerciseSet.previewSet) { _ in }
        }
    }
}
