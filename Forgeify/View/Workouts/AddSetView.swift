//
//  AddSetView.swift
//  Forgeify
//
//  Created by Robert Basamac on 03.10.2023.
//

import SwiftUI

struct AddSetView: View {
    @Environment(\.dismiss) var dismiss
        
    @State private var exerciseSet: ExerciseSet
    @State private var reps: Int
    @State private var weight: Int
    @State private var rest: Int
    
    private var onDone: (ExerciseSet) -> Void
    
    init(exerciseSet: ExerciseSet, completion: @escaping (ExerciseSet) -> Void) {
        self._exerciseSet = State(initialValue: exerciseSet)
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
        .scrollDisabled(true)
        .toolbar {
            toolbarItems()
            keyboardToolbarItems()
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
                Text("Dimiss")
            }
        }
    }
    
    @ToolbarContentBuilder
    private func keyboardToolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            HStack {
                Spacer()
                Button {
                    updateSet()
                    onDone(exerciseSet)
                    
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            AddSetView(exerciseSet: ExerciseSet(weight: 0, reps: 0, rest: 0)) { _ in }
        }
    }
}
