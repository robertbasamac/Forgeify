//
//  WorkoutDetailView.swift
//  Forgeify
//
//  Created by Robert Basamac on 12.10.2023.
//

import SwiftUI
import SwiftData

struct WorkoutDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    
    private var workout: Workout
    
    @State private var title: String = ""
    @State private var exercises: [WorkoutExercise]
    @State private var showAddExercise: Bool = false
    @State private var editModeCancelled: Bool = false
    
    init(workout: Workout) {
        self.workout = workout
        self._exercises = State(initialValue: workout.sortedExercises)
    }
    
    var body: some View {
        Form {
            if isEditModeActive() {
                titleSection()
            }
            
            exercisesSection()
            
            if isEditModeActive() {
                addButton()
            }
        }
        .navigationTitle(title.isEmpty ? workout.title : title)
//        .animation(nil, value: editMode?.wrappedValue)
        .onChange(of: editMode?.wrappedValue, { _, newValue in
            if newValue?.isEditing ?? false && !editModeCancelled {
                updateWorkout()
            }
            editModeCancelled = false
        })
        .toolbar {
            toolbarItems()
        }
        .navigationDestination(isPresented: $showAddExercise) {
            ExerciseSelectionView(selections: $exercises)
        }
    }
}

// MARK: - Helper Methods
extension WorkoutDetailView {
    private func sortedExercises() -> [WorkoutExercise] {
        return exercises.sorted { $0.index < $1.index }
    }
    
    private func delete(at offsets: IndexSet) {
        withAnimation {
            exercises.remove(atOffsets: offsets)
        }
    }
    
    private func move(fromOffsets source: IndexSet, toOffsets destination: Int) {
        withAnimation {
            exercises.move(fromOffsets: source, toOffset: destination)
        }
    }
    
    private func updateWorkout() {
        if !title.isEmpty {
            workout.title = title
        }
        
        for index in exercises.indices {
            exercises[index].index = index
        }
        workout.exercises = exercises
    }
    
    private func isEditModeActive() -> Bool {
        return editMode?.wrappedValue.isEditing ?? false
    }
}

// MARK: - Components
extension WorkoutDetailView {
    @ViewBuilder
    private func titleSection() -> some View {
        Section {
            TextField(workout.title.isEmpty ? "Enter title here…" : workout.title, text: $title)
                .textInputAutocapitalization(.words)
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
            Text("Workout Title")
        }
    }
    
    @ViewBuilder
    private func exercisesSection() -> some View {
        if !exercises.isEmpty {
            Section {
                ForEach(exercises) { exercise in
                    NavigationLink {
                        UpdateWorkoutExerciseView(exercise: exercise)
                    } label: {
                        ExerciseRowView(exercise: exercise)
                    }
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            } header: {
                Text("Exercises")
            }
        } else {
            Text("No exercises. Add one by pressing the below \"Add Exercise\" button")
        }
    }
    
    @ViewBuilder
    private func addButton() -> some View {
        Button {
            showAddExercise.toggle()
        } label: {
            Label("Add Exercises", systemImage: "plus")
        }
    }
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            if isEditModeActive() {
                Button(role: .cancel) {
                    withAnimation {
                        exercises = workout.exercises.sorted { $0.index < $1.index }
                        editMode?.wrappedValue = .inactive
                    }
                } label: {
                    Text("Cancel")
                }
            }
            EditButton()
                .bold(isEditModeActive())
        }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            WorkoutDetailView(workout: Workout.previewWorkout)
        }
    }
}
