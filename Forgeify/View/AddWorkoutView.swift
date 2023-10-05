//
//  AddWorkoutView.swift
//  Forgeify
//
//  Created by Robert Basamac on 28.09.2023.
//

import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var exercises: [WorkoutExercise] = []
    
    @State private var showAddExercise: Bool = false
    
    var body: some View {
        Form {
            titleSection()
            exercisesSection()
            addButton()
        }
        .navigationTitle("Create new Workout")
        .toolbar {
            toolbarItems()
        }
        .navigationDestination(isPresented: $showAddExercise) {
            ExerciseSelectionView(selections: exercises) { selections in
                exercises = selections
            }
        }
    }
    
    private func isDoneButtonDisabled() -> Bool {
        return title.isEmpty
    }
    
    private func deleteExercises(at offsets: IndexSet) {
        withAnimation {
            exercises.remove(atOffsets: offsets)
        }
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving the context.")
        }
    }
}


// MARK: - View Components
extension AddWorkoutView {
    @ViewBuilder
    private func titleSection() -> some View {
        Section(header: Text("Workout Title")) {
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
        }
    }
    
    @ViewBuilder
    private func exercisesSection() -> some View {
        ForEach(exercises) { exercise in
            Section {
                NavigationLink {
                    Text(exercise.title)
                } label: {
                    Text(exercise.title)
                }
                
                ForEach(exercise.sets) { exercise in
                    Text("\(exercise.weight)")
                }
                .deleteDisabled(true)
            } header: {
                let index = exercises.firstIndex { $0.id == exercise.id } ?? 0
                Text("Exercise \(index + 1)")
            }
        }
        .onDelete(perform: deleteExercises)
    }
    
    @ViewBuilder
    private func addButton() -> some View {
        Button {
            // TODO: Open a sheet to select from the exercises collection or create a new exercise
            showAddExercise.toggle()
        } label: {
            Label("Add Exercises", systemImage: "plus")
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                dismiss()
            }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("Done") {
                let workout = Workout(title: title, exercises: exercises)

                for exercise in exercises {
                    modelContext.insert(exercise)
                }
                
                modelContext.insert(workout)
                
                save()
                dismiss()
            }
            .disabled(isDoneButtonDisabled())
        }
    }
}

#Preview {
    NavigationStack {
        AddWorkoutView()
    }
}
