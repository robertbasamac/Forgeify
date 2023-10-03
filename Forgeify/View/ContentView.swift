//
//  ContentView.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [Workout]
    
    @State private var showAddWorkout = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(workouts) { workout in
                    WorkoutItem(workout: workout)
                }
                .onDelete(perform: deleteWorkouts)
            }
            .navigationTitle("Workouts")
            .scrollDisabled(workouts.isEmpty)
            .overlay {
                emptyWorkoutsView()
            }
            .toolbar {
                toolbarItems()
            }
            .navigationDestination(for: Workout.self) { workout in
                Text(workout.title)
            }
            .fullScreenCover(isPresented: $showAddWorkout) {
                NavigationStack {
                    AddWorkoutView()
                }
            }
        }
    }
    
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
extension ContentView {
    @ViewBuilder
    private func emptyWorkoutsView() -> some View {
        if workouts.isEmpty {
            ContentUnavailableView {
                Label("No Workouts", systemImage: "figure.run.circle")
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

#Preview {
    ContentView()
}
