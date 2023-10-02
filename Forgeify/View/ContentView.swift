//
//  ContentView.swift
//  Forgeify
//
//  Created by Robert Basamac on 27.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var workouts: [Workout]
    
    @State private var showAddWorkout = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(workouts) { workout in
                    WorkoutItem(workout: workout)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(workouts[index])
                    }
                }
            }
            .navigationTitle("Workouts")
            .scrollDisabled(workouts.isEmpty)
            .overlay {
                if workouts.isEmpty {
                    ContentUnavailableView {
                        Label("No Workouts", systemImage: "figure.run.circle")
                    } description: {
                        Text("New workouts you create will appear here.\nUse the '+' button above to create new workouts.")
                    } actions: {
                        Button {
                            showAddWorkout.toggle()
                        } label: {
                            Text("Add Workout")
                        }
                        
                    }
                }
            }
            .toolbar {
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
}

#Preview {
    ContentView()
}
