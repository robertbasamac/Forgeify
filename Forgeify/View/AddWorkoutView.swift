//
//  AddWorkoutView.swift
//  Forgeify
//
//  Created by Robert Basamac on 28.09.2023.
//

import SwiftUI

struct AddWorkoutView: View {
    @EnvironmentObject private var workoutManager: WorkoutManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var exercises: [Exercise] = Exercise.previewExercises
    
    var body: some View {
        Form {
            Section(header: Text("Workout Title")) {
                TextField("Enter title here…", text: $title)
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
            }
            
            Section {
                ForEach($exercises) { exercise in
                    HStack {
                        let index = exercises.firstIndex { $0.id == exercise.id } ?? 0
                        
                        Circle()
                            .frame(width: 24, height: 24)
                            .overlay {
                                Text("\(index + 1)")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.background)
                            }
                            .padding(.trailing)
                        
                        TextField("Enter title here…", text: exercise.title)
                            .overlay(alignment: .trailing) {
                                Button {
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(.plain)
                                .opacity(title.isEmpty ? 0 : 1)
                            }
                            .padding(.trailing, 30)
                            .padding(.leading, 4)
                            .padding(2)
                            .background(.fill.quaternary, in: .rect(cornerRadius: 6))

                    }
                }
            } header: {
                Text("Exercises")
            } footer: {
                Button {
                    exercises.append(Exercise(title: ""))
                } label: {
                    Text("add exercise")
                        .font(.caption)
                }
            }
        }
        .navigationTitle("Add Workout")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    addWorkout()
                    dismiss()
                }
                .disabled(title.isEmpty)
            }
        }
    }
    
    private func addWorkout() {
        withAnimation {
            let newWorkout = Workout(title: title, exercises: [Exercise.previewExercise])
            workoutManager.workouts.append(newWorkout)
        }
    }
}

#Preview {
    NavigationStack {
        AddWorkoutView()
            .environmentObject(WorkoutManager.preview)
    }
}
