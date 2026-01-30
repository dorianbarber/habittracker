//
//  LogbookRow.swift
//  habittracker
// 
//  Created by Dorian Barber on 1/28/26.
//

import SwiftUI
import SwiftData

struct LogbookRowView: View {
    let activity: Activity
    @State private var isPresentingSheet = false
    
    var body: some View {
        Button {
            isPresentingSheet = true
        } label: {
            HStack {
                Text(timeString(activity.elapsedSeconds))
                    .font(.headline)
                if let label = activity.label, !label.isEmpty {
                    Text(label)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(activity.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isPresentingSheet) {
            ActivityDetailSheet(activity: activity)
        }
    }
    
    private func timeString(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
}

struct ActivityDetailSheet: View {
    let activity: Activity

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var editedLabel: String = ""
    @State private var editedNotes: String = ""
    @State private var editedTag: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Time")) {
                    Text(timeString(activity.elapsedSeconds))
                }
                Section(header: Text("Details")) {
                    TextField("Label", text: $editedLabel)
                    TextField("Tag", text: $editedTag)
                    VStack(alignment: .leading) {
                        Text("Notes")
                            .font(.headline)
                        TextEditor(text: $editedNotes)
                            .frame(minHeight: 120)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.2)))
                    }
                }
                Section(header: Text("Date")) {
                    HStack {
                        Text("Date Created")
                        Spacer()
                        Text(activity.date, style: .date)
                            .foregroundStyle(.secondary)
                    }
                }
                Section() {
                    Button(action: deleteActivity){
                        HStack {
                            Spacer()
                            Text("Delete Activity")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Edit Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveChanges() }
                        .disabled(!canSave())
                }
            }
        }
        .onAppear {
            editedLabel = activity.label ?? ""
            editedNotes = activity.notes ?? ""
            editedTag = activity.tag ?? ""
        }
        .presentationDetents([.medium, .large])
    }
    
    private func canSave() -> Bool{
        return editedLabel.isEmpty == false || editedNotes.isEmpty == false || editedTag.isEmpty == false
    }

    private func saveChanges() {
        activity.label = editedLabel.isEmpty ? nil : editedLabel
        activity.notes = editedNotes.isEmpty ? nil : editedNotes
        activity.tag = editedTag.isEmpty ? nil : editedTag
        do {
            try modelContext.save()
        } catch {
            print("Failed to save activity: \(error)")
        }
        dismiss()
    }

    private func deleteActivity() {
        modelContext.delete(activity)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete activity: \(error)")
        }
        dismiss()
    }
    
    private func timeString(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
}

#Preview("Logbook Row - With Label") {
    let sample = Activity(elapsedSeconds: 3723, label: "Morning Run", notes: "Felt great today", date: Date(), tag: "fitness")
    return LogbookRowView(activity: sample)
        .padding()
}

#Preview("Activity Detail Sheet - Editing") {
    let sample = Activity(elapsedSeconds: 5400, label: "Study Session", notes: "Read chapters 3-4", date: Date(), tag: "learning")
    return ActivityDetailSheet(activity: sample)
}

