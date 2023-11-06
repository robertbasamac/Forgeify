//
//  ModelContainerPreview.swift
//  Forgeify
//
//  Created by Robert Basamac on 14.10.2023.
//

import SwiftData
import SwiftUI

struct ModelContainerPreview<Content: View>: View {
    var content: () -> Content
    let container: ModelContainer

    /// Creates an instance of the model container preview.
    ///
    /// This view creates the model container before displaying the preview
    /// content. The view is intended for use in previews only.
    ///
    ///     #Preview {
    ///         ModelContainerPreview {
    ///             List {
    ///                 WorkoutListItem(workout: Workout.previewWorkout)
    ///             }
    ///         } modelContainer: {
    ///             let schema = Schema([Workout.self, ExerciseSet.self, Exercise.self])
    ///             let configuration = ModelConfiguration(inMemory: true)
    ///             let container = try! ModelContainer(for: schema, configurations: [configuration])
    ///             let sampleData: [any PersistentModel] = [
    ///                 Workout.previewWorkout, Exercise.previewExercise
    ///             ]
    ///             Task { @MainActor in
    ///                 sampleData.forEach {
    ///                     container.mainContext.insert($0)
    ///                 }
    ///             }
    ///             return container
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - content: A view that describes the content to preview.
    ///   - modelContainer: A closure that returns a model container.
    init(@ViewBuilder content: @escaping () -> Content, modelContainer: @escaping () throws -> ModelContainer) {
        self.content = content
        do {
            self.container = try MainActor.assumeIsolated(modelContainer)
        } catch {
            fatalError("Failed to create the model container: \(error.localizedDescription)")
        }
    }

    /// Creates a view that creates the provided model container before display
    /// the preview content.
    ///
    /// This view creates the model container before displaying the preview
    /// content. The view is intended for use in previews only.
    ///
    ///     #Preview {
    ///         ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
    ///             List {
    ///                 WorkoutItem(workout: Workout.previewWorkout)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - modelContainer: A closure that returns a model container.
    ///   - content: A view that describes the content to preview.
    init(_ modelContainer: @escaping () throws -> ModelContainer, @ViewBuilder content: @escaping () -> Content) {
        self.init(content: content, modelContainer: modelContainer)
    }

    var body: some View {
        content()
            .modelContainer(container)
    }
}
