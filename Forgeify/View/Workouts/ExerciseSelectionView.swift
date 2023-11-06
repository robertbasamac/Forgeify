//
//  ExerciseSelectionView.swift
//  Forgeify
//
//  Created by Robert Basamac on 02.10.2023.
//

import SwiftUI
import SwiftData

struct ExerciseSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Exercise.title) private var exercises: [Exercise]
    
    @Binding private var exerciseSetInfo: [Exercise: [ExerciseSet]]

    @State private var showAddExercise: Bool = false
    
    init(exerciseSetInfo: Binding<[Exercise: [ExerciseSet]]>) {
        self._exerciseSetInfo = Binding(projectedValue: exerciseSetInfo)
    }
    
    var body: some View {
        List {
            ForEach(exercises){ exercise in
                HStack {
                    Image(systemName: getItemCheckmark(for: exercise))
                    Text(exercise.title)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(.rect)
                .onTapGesture {
                    handleSelection(of: exercise)
                }
            }
        }
        .navigationTitle("Add Exercises")
        .scrollDisabled(exercises.isEmpty)
        .overlay {
            emptyExercisesView()
        }
        .toolbar {
            toolbarItems()
        }
        .navigationDestination(isPresented: $showAddExercise) {
            AddExerciseView()
        }
    }
}

// MARK: - Helper methods
extension ExerciseSelectionView {
    private func handleSelection(of exercise: Exercise) {
        if exerciseSetInfo[exercise] != nil {
            exerciseSetInfo.removeValue(forKey: exercise)
        } else {
            exerciseSetInfo[exercise] = [ExerciseSet]()
            
            let exerciseSet = ExerciseSet()
            exerciseSet.exercise = exercise
            
            exerciseSetInfo[exercise]?.append(exerciseSet)
        }
    }
    
    private func getItemCheckmark(for exercise: Exercise) -> String {
        return exerciseSetInfo[exercise] != nil ? "checkmark.circle.fill" : "circle"
    }
 }

// MARK: - Components
extension ExerciseSelectionView {
    @ViewBuilder
    private func emptyExercisesView() -> some View {
        if exercises.isEmpty {
            ContentUnavailableView {
                Label("No Exercise in your collection.", systemImage: "figure.run.circle")
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
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showAddExercise.toggle()
            } label: {
                Label("Create new Exercise", systemImage: "plus")
            }
        }
    }
}


// MARK: - Preview
#Preview("Filled") {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            ExerciseSelectionView( exerciseSetInfo: .constant([:]))
        }
    }
}

#Preview("Empty") {
    ModelContainerPreview(PreviewSampleData.emptyInMemoryContainer) {
        NavigationStack {
            ExerciseSelectionView(exerciseSetInfo: .constant([:]))
        }
    }
}
