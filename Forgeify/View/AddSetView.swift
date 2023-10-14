//
//  AddSetView.swift
//  Forgeify
//
//  Created by Robert Basamac on 03.10.2023.
//

import SwiftUI

struct AddSetView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var weight: Int = 0
    @State private var reps: Int = 0
    @State private var rest: Int = 0
    
    @Binding var sets: [ExerciseSet]
        
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Weight")
                    Spacer()
                    TextField("Weight", value: $weight, formatter: NumberFormatter())
                }
            }
            Section {
                HStack {
                    Text("Reps")
                    Spacer()
                    TextField("Reps", value: $reps, formatter: NumberFormatter())
                }
            }
            Section {
                HStack {
                    Text("Rest")
                    Spacer()
                    TextField("Rest", value: $rest, formatter: NumberFormatter())
                }
            }
        }
        .navigationTitle("Add new Set")
        .toolbarTitleDisplayMode(.inline)
        .scrollDisabled(true)
        .multilineTextAlignment(.trailing)
        .keyboardType(.numberPad)
        .toolbar {
            toolbarItems()
            keyboardToolbarItems()
        }
    }
}

// MARK: - Components
extension AddSetView {
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button {
                let set = ExerciseSet(weight: weight, reps: reps, rest: rest)
                sets.append(set)
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
                Button("Done") {
                    let set = ExerciseSet(weight: weight, reps: reps, rest: rest)
                    sets.append(set)
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.emptyInMemoryContainer) {
        @State var exerciseSets: [ExerciseSet] = []
        NavigationStack {
            AddSetView(sets: $exerciseSets)
        }
    }
}
