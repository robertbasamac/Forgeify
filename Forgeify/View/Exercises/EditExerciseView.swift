//
//  UpdateExerciseView.swift
//  Forgeify
//
//  Created by Robert Basamac on 02.11.2023.
//

import SwiftUI
import SwiftData

struct EditExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private var exercise: Exercise
    
    @State private var title: String = ""
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    var body: some View {
        Form {
            Section {
                TextField(exercise.title.isEmpty ? "Enter title here…" : exercise.title, text: $title)
                    .textInputAutocapitalization(.words)
            } header: {
                Text("Exercise Title")
            } footer: {
                Text("Note: this title will be updated in all workouts that include this exercise.")
            }
        }
        .navigationTitle("Edit Exercise")
        .toolbar {
            toolbarItems()
        }
    }
}

// MARK: - Helper Methods
extension EditExerciseView {
    private func updateExercise() {
        if !title.isEmpty {
            exercise.title = title
        }
        
//        save()
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
extension EditExerciseView {
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
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button {
                updateExercise()
                
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
            EditExerciseView(exercise: Exercise.previewExercise)
        }
    }
}
