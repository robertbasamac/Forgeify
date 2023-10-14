//
//  AddExerciseView.swift
//  Forgeify
//
//  Created by Robert Basamac on 02.10.2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
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
            toolbarItems()
        }
        .sheet(isPresented: $showAddSet) {
            NavigationStack {
                AddSetView(sets: $sets)
            }
            .presentationDetents([.fraction(0.45)])
            .presentationCornerRadius(20)
            .interactiveDismissDisabled()
        }
    }
    
    private func isSaveButtonDisabled() -> Bool {
        return title.isEmpty
    }
    
    private func delete(at offsets: IndexSet) {
        withAnimation {
            sets.remove(atOffsets: offsets)
        }
    }
    
    private func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        withAnimation {
            sets.move(fromOffsets: source, toOffset: destination)
        }
    }
}

// MARK: - Components
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
        if !sets.isEmpty {
            Section {
                ForEach(sets) { set in
                    HStack {
                        Text("Weight: \(set.weight)")
                        Text("Reps: \(set.reps)")
                        Text("Rest: \(set.rest)")
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }  header: {
                Text("Sets")
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
    
    @ToolbarContentBuilder
    private func toolbarItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            EditButton()
            
            Button("Save") {
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
            .disabled(isSaveButtonDisabled())
        }
    }
}

#Preview {
    ModelContainerPreview(PreviewSampleData.inMemoryContainer) {
        NavigationStack {
            AddExerciseView() { _ in }
        }
    }
}
