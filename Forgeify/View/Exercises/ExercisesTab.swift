//
//  ExercisesTab.swift.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.10.2023.
//

import SwiftUI
import SwiftData

struct ExercisesTab: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Exercise.title, order: .forward) private var exercises: [Exercise]
    
    @State private var showAddExercise: Bool = false
    
    var body: some View {
        List {
            ForEach(exercises) { exercise in
                Section {
                    NavigationLink {
                        Text(exercise.title)
//                        EditExerciseView(exercise: exercise)
                    } label: {
                        Text(exercise.title)
                    }

                }
            }
            .onDelete(perform: deleteExercises)
        }
        .navigationTitle("Exercises")
        .listSectionSpacing(.compact)
        .scrollDisabled(exercises.isEmpty)
        .overlay {
            emptyExerciseView()
        }
        .toolbar {
            toolbarItems()
        }
        .sheet(isPresented: $showAddExercise) {
            AddExerciseView(onAdd: { _ in })
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(25)
        }
    }
}

// MARK: - Helper Methods
extension ExercisesTab {
    private func deleteExercises(at offsets: IndexSet) {
        withAnimation {
            offsets.map { exercises[$0] }.forEach(deleteExercise)
        }
    }
    
    private func deleteExercise(_ exercise: Exercise) {
        modelContext.delete(exercise)
        
        for workoutExercise in exercise.exercises {
            modelContext.delete(workoutExercise)
        }
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
extension ExercisesTab {
    @ViewBuilder
    private func emptyExerciseView() -> some View {
        if exercises.isEmpty {
            ContentUnavailableView {
                Label("No Exercises in your collection.", systemImage: "figure.run.circle")
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
        ToolbarItem(placement: .topBarLeading) {
            EditButton()
                .disabled(exercises.isEmpty)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showAddExercise = true
            } label: {
                Label("Add Workout", systemImage: "plus")
            }
        }
    }
}

// MARK: - Preview
#Preview("Filled") {
    NavigationStack {
        ExercisesTab()
            .modelContainer(PreviewSampleData.container)
    }
}

#Preview("Empty") {
    NavigationStack {
        ExercisesTab()
            .modelContainer(PreviewSampleData.emptyContainer)
    }
}
