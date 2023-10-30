//
//  WorkoutsTab.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.09.2023.
//

import SwiftUI
import SwiftData

struct WorkoutsTab: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workout.title, order: .forward) private var workouts: [Workout]
    
    @State private var showAddWorkout = false
    
    var body: some View {
        List {
            ForEach(workouts) { workout in
                Section {
                    WorkoutListItem(workout: workout)
                }
            }
            .onDelete(perform: deleteWorkouts)
        }
        .navigationTitle("Workouts")
        .scrollDisabled(workouts.isEmpty)
        .listSectionSpacing(.compact)
        .overlay {
            emptyWorkoutsView()
        }
        .toolbar {
            toolbarItems()
        }
        .navigationDestination(for: Workout.self) { workout in
            WorkoutDetailView(workout: workout)
        }
        .fullScreenCover(isPresented: $showAddWorkout) {
            NavigationStack {
                AddWorkoutView()
            }
        }
    }
}

// MARK: - Helper Methods
extension WorkoutsTab {
    private func deleteWorkouts(at offsets: IndexSet) {
        withAnimation {
            offsets.map { workouts[$0] }.forEach(deleteWorkout)
        }
    }
    
    private func deleteWorkout(_ workout: Workout) {
        modelContext.delete(workout)
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
extension WorkoutsTab {
    @ViewBuilder
    private func emptyWorkoutsView() -> some View {
        if workouts.isEmpty {
            ContentUnavailableView {
                Label("No Workouts in your collection.", systemImage: "figure.run.circle")
            } description: {
                Text("New workouts you create will appear here.\nTap the botton below to create a new workout.")
            } actions: {
                Button {
                    showAddWorkout.toggle()
                } label: {
                    Text("Add Workout")
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
                .disabled(workouts.isEmpty)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showAddWorkout = true
            } label: {
                Label("Add Workout", systemImage: "plus")
            }
        }
    }
}

// MARK: - Preview
#Preview("Filled") {
    NavigationStack {
        WorkoutsTab()
            .modelContainer(PreviewSampleData.container)
    }
}

#Preview("Empty") {
    NavigationStack {
        WorkoutsTab()
            .modelContainer(PreviewSampleData.emptyContainer)
    }
}
