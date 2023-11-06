//
//  AddExerciseView.swift
//  Forgeify
//
//  Created by Robert Basamac on 31.10.2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter title here...", text: $title)
                        .textInputAutocapitalization(.words)
                        .focused($isTitleFocused)
                        .task {
                            isTitleFocused = true
                        }
                } header: {
                    Text("Title")
                }
            }
            .navigationTitle("Create new Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarItems()
            }
        }        
    }
}

// MARK: - Helper Methods
extension AddExerciseView {
    private func addExercise() {
        let exercise = Exercise(title: title)
        modelContext.insert(exercise)
        
        save()
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving context.")
        }
    }
    
    private func isDoneButtonDisabled() -> Bool {
        return title.isEmpty
    }
}

// MARK: - Components
extension AddExerciseView {
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {        
        ToolbarItem(placement: .confirmationAction) {
            Button {
                addExercise()
                
                dismiss()
            } label: {
                Text("Done")
            }
            .disabled(isDoneButtonDisabled())
        }
    }
}

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            AddExerciseView()
        }
    }
}
