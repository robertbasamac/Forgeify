//
//  AddExerciseView.swift
//  Forgeify
//
//  Created by Robert Basamac on 02.10.2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var sets: [ExerciseSet] = []
    
    @State private var showAddSet: Bool = false
    
    var onAdd: (WorkoutExercise) -> Void

    var body: some View {
        Form {
            titleSection
            setsSection
            addButton
        }
        .navigationTitle("Create new Exercise")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    let exercise = WorkoutExercise(title: title, sets: sets)
                    modelContext.insert(exercise)
                    
                    do {
                        try modelContext.save()
                    } catch {
                        print("Error saving context.")
                    }
                    
                    onAdd(exercise)
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showAddSet) {
            NavigationStack {
                AddSetView(sets: $sets)
            }
            .presentationDetents([.medium])
        }
    }
}

struct AddSetView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var weight: Int = 0
    @State private var reps: Int = 0
    @State private var rest: Int = 0
    
    @Binding var sets: [ExerciseSet]
        
    var body: some View {
        Form {
            Section {
                TextField("Weight", value: $weight, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            }
            Section {
                
                TextField("Weight", value: $reps, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            }
            
            Section {
                TextField("Weight", value: $rest, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    let set = ExerciseSet(weight: weight, reps: reps, rest: rest)
                    sets.append(set)
                    dismiss()
                }
            }
        }
    }
}

// MARK: - View Components
extension AddExerciseView {
    @ViewBuilder
    private var titleSection: some View {
        Section(header: Text("Exercise Title")) {
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
    }
    
    @ViewBuilder
    private var setsSection: some View {
        Section {
            ForEach(sets) { set in
                HStack {
                    Text("Weight: \(set.weight)")
                    Text("Reps: \(set.reps)")
                    Text("Rest: \(set.rest)")
                }
            }
        }
    }
    
    @ViewBuilder
    private var addButton: some View {
        Button {
            showAddSet.toggle()
        } label: {
            Label("Add Set", systemImage: "plus")
        }
    }
}

#Preview {
    AddExerciseView() { _ in }
}
