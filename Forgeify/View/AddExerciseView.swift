//
//  AddExerciseView.swift
//  Forgeify
//
//  Created by Robert Basamac on 02.10.2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    
    var onAdd: (Exercise) -> Void
    
    var body: some View {
        Form {
            Section {
                TextField("Enter title here…", text: $title)
                    .padding(.trailing, 30)
                    .overlay(alignment: .trailing) {
                        Button {
                            title = ""
                        } label: {
                            Image(systemName: "xmark.circle")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                        .opacity(title.isEmpty ? 0 : 1)
                    }
            } header: {
                Text("Exercise Title")
            }
        }
        .navigationTitle("Create new Exercise")
        .toolbar {
            toolbarItems()
        }
    }
}

// MARK: - Helper Methods
extension AddExerciseView {
    private func isSaveButtonDisabled() -> Bool {
        return title.isEmpty
    }
}

// MARK: - Components
extension AddExerciseView {
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            EditButton()
            
            Button("Save") {
                let exercise = Exercise(title: title)
                modelContext.insert(exercise)
                
                do {
                    try modelContext.save()
                } catch {
                    print("Error saving context.")
                }
                
                onAdd(exercise)
                dismiss()
            }
            .disabled(isSaveButtonDisabled())
        }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            AddExerciseView() { _ in }
        }
    }
}
