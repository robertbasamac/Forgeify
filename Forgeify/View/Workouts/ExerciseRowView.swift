//
//  ExerciseRowView.swift
//  Forgeify
//
//  Created by Robert Basamac on 01.11.2023.
//

import SwiftUI

struct ExerciseRowView: View {
    private let exercise: Exercise
    private let sets: [ExerciseSet]
    
    private let columns = [GridItem(.fixed(14), spacing: 0), GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)]
    
    init(exercise: Exercise, sets: [ExerciseSet]) {
        self.exercise = exercise
        self.sets = sets
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.title)
                .font(.headline)
            
            if !sets.isEmpty {
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
    private func indexedExerciseSets() -> [(Int, ExerciseSet)] {
        sets.enumerated().map { ($0 + 1, $1) }
    }
}

// MARK: - Previews
#Preview("Filled") {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            List {
                ExerciseRowView(exercise: Exercise.previewExercise, sets: ExerciseSet.previewSets)
            }
        }
    }
}
