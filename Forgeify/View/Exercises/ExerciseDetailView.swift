//
//  ExerciseDetailView.swift
//  Forgeify
//
//  Created by Robert Basamac on 13.10.2023.
//

import SwiftUI

struct ExerciseDetailView: View {
    var exercise: WorkoutExercise
    
    var body: some View {
        List {
            Text(exercise.title)
        }
    }
}

// MARK: - Preview
#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        ExerciseDetailView(exercise: WorkoutExercise.previewExercise)
    }
}
