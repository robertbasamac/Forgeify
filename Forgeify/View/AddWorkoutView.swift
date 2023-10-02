//
//  AddWorkoutView.swift
//  Forgeify
//
//  Created by Robert Basamac on 28.09.2023.
//

import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var exercises: [WorkoutExercise] = []
    
    @State private var showAddExercise: Bool = false
    
    var body: some View {
        Form {
            titleSection
            exercisesSection
            addButton
        }
        .navigationTitle("Create new Workout")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
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
        .navigationDestination(isPresented: $showAddExercise) {
            ExerciseSelectionView(selections: exercises) { selections in
                exercises = selections
            }
        }
    }
    
    private func isDoneButtonDisabled() -> Bool {
        return title.isEmpty
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
    private var titleSection: some View {
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
    private var exercisesSection: some View {
        ForEach(exercises) { exercise in
            Section {
                NavigationLink {
                    Text(exercise.title)
                } label: {
                    VStack(alignment: .leading) {
                        Text(exercise.title)
                    }
                }
                
                ForEach(exercise.sets) { exercise in
                    Text("\(exercise.weight)")
                }
            } header: {
                let index = exercises.firstIndex { $0.id == exercise.id } ?? 0
                Text("Exercise \(index + 1)")
            }
        }
    }
    
    @ViewBuilder
    private var addButton: some View {
        Button {
            // TODO: Open a sheet to select from the exercises collection or create a new exercise
            showAddExercise.toggle()
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("Add Exercises")
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddWorkoutView()
    }
}
