//
//  ExerciseListItem.swift
//  Forgeify
//
//  Created by Robert Basamac on 09.10.2023.
//

import SwiftUI
import SwiftData

struct ExerciseRowView: View {
    @Environment(\.editMode) private var editMode
    
    private let exercise: WorkoutExercise
    
    private let columns = [GridItem(.fixed(14), spacing: 0), GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)]
    
    init(exercise: WorkoutExercise) {
        self.exercise = exercise
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.title)
                .font(.headline)
            
            if !exercise.sets.isEmpty && editMode?.wrappedValue == .inactive {
                Divider()
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(indexedExerciseSets(), id: \.1.id) { (index, exerciseSet) in
                        Text("\(index):")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(exerciseSet.weight)")
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if index == 1 {
                                    Text("Weight").font(.caption).foregroundStyle(.secondary)
                                        .offset(y: -20)
                                }
                            }
                        Text("\(exerciseSet.reps)")
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if index == 1 {
                                    Text("Reps").font(.caption).foregroundStyle(.secondary)
                                        .offset(y: -20)
                                }
                            }
                        Text("\(exerciseSet.rest)")
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if index == 1 {
                                    Text("Rest").font(.caption).foregroundStyle(.secondary)
                                        .offset(y: -20)
                                }
                            }
                    }
                    .font(.subheadline)
                }
                .padding(.top, 16)
            }
        }
    }
}
 
// MARK: - Helper Methods
extension ExerciseRowView {
    private func indexedExerciseSets(/*for exercise: WorkoutExercise*/) -> [(Int, ExerciseSet)] {
        exercise.sets.enumerated().map { ($0 + 1, $1) }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            List {
                ExerciseRowView(exercise: WorkoutExercise.previewExercise)
            }
        }
    }
}
