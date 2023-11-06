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
                        EditExerciseView(exercise: exercise)
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
        .background(Color(uiColor: .systemGroupedBackground)) // to avoid the color glitch when opening the keyboard
        .overlay {
            emptyExerciseView()
        }
        .toolbar {
            toolbarItems()
        }
        .navigationDestination(for: Exercise.self) { exercise in
            EditExerciseView(exercise: exercise)
        }
        .sheet(isPresented: $showAddExercise) {
            AddExerciseView()
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(25)
                .presentationBackground(Color(uiColor: .systemGroupedBackground)) // to avoid the color glitch when opening the keyboard
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
        withAnimation {
            modelContext.delete(exercise)
            
            for exerciseSet in exercise.exerciseSets {
                modelContext.delete(exerciseSet)
            }
            
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
            .background(Color(uiColor: .systemGroupedBackground))
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