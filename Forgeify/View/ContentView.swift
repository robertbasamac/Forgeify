//
//  ContentView.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.09.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @State private var showAddWorkout = false
    @State private var selection: Workout?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(workoutManager.workouts) { workout in
                    WorkoutItem(workout: workout)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteWorkout(workout)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onDelete(perform: deleteWorkouts(at:))

            }
            .overlay {
                if workoutManager.workouts.isEmpty {
                    ContentUnavailableView {
                         Label("No Workouts", systemImage: "figure.run.circle")
                    } description: {
                         Text("New workouts you create will appear here.")
                    }
                }
            }
            .navigationTitle("Workouts")
            .navigationDestination(for: Workout.self) { workout in
                Text(workout.title)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                        .disabled(workoutManager.workouts.isEmpty)
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
        .sheet(isPresented: $showAddWorkout) {
            NavigationStack {
                AddWorkoutView()
            }
        }
    }
    
    private func deleteWorkouts(at offsets: IndexSet) {
        withAnimation {
            offsets.map { workoutManager.workouts[$0] }.forEach(deleteWorkout)
        }
    }
    
    private func deleteWorkout(_ workout: Workout) {
        workoutManager.workouts.removeAll { $0.id == workout.id }
    }
}

#Preview {
    ContentView()
        .environmentObject(WorkoutManager.preview)
}
