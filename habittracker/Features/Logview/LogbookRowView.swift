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
            HStack(spacing: 6) {
                Text(timeString(activity.elapsedSeconds))
                    .font(.body.bold())
                    .foregroundStyle(.primary)
                if let label = activity.label, !label.isEmpty {
                    Text(label)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(activity.date, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isPresentingSheet) {
            ActivityDetailSheet(activity: activity)
                .presentationDetents([.large])
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
    
    @Query(sort: \Tag.tag, order: .forward) private var tags:
        [Tag]

    @State private var editedLabel: String = ""
    @State private var editedNotes: String = ""
    @State private var selectedTag: Tag?
    @State private var isPresentingNewTag = false
    @State private var newTagText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Time").font(.footnote.bold())) {
                    Text(timeString(activity.elapsedSeconds))
                        .font(.body)
                        .foregroundStyle(.primary)
                }
                .listRowBackground(Color(white: 0.98))
                
                Section(header: Text("Details").font(.footnote.bold())) {
                    TextField("Label", text: $editedLabel)
                        .font(.body)
                        .foregroundColor(.primary)
                    Picker("Tag", selection: $selectedTag) {
                        Text("None").tag(Optional<Tag>(nil))
                            .font(.body)
                            .foregroundColor(.secondary)
                        ForEach(tags, id: \.self) { tag in
                            Text(tag.tag)
                                .font(.body)
                                .foregroundColor(.primary)
                                .tag(Optional(tag))
                        }
                    }
                    .pickerStyle(.navigationLink)
                    Button {
                        isPresentingNewTag = true
                    } label: {
                        Label("Add New Tag", systemImage: "plus")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notes")
                            .font(.footnote.bold())
                            .foregroundStyle(.primary)
                        TextEditor(text: $editedNotes)
                            .font(.body)
                            .foregroundColor(.primary)
                            .frame(minHeight: 120)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.15)))
                    }
                }
                .listRowBackground(Color(white: 0.98))
                
                Section(header: Text("Date").font(.footnote.bold())) {
                    HStack(spacing: 4) {
                        Text("Date Created")
                            .font(.body)
                            .foregroundStyle(.primary)
                        Spacer()
                        Text(activity.date, style: .date)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }
                .listRowBackground(Color(white: 0.98))
                
                Section() {
                    Button(action: deleteActivity){
                        HStack {
                            Spacer()
                            Text("Delete Activity")
                                .font(.body)
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
                .listRowBackground(Color(white: 0.98))
            }
            .navigationTitle("Edit Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .font(.body)
                        .foregroundColor(.primary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveChanges() }
                        .disabled(!canSave())
                        .font(.body)
                        .foregroundColor(canSave() ? .primary : .secondary)
                }
            }
            .sheet(isPresented: $isPresentingNewTag) {
                NavigationStack {
                    Form {
                        TextField("New tag name", text: $newTagText)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .navigationTitle("New Tag")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { isPresentingNewTag = false; newTagText = "" }
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let trimmed = newTagText.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !trimmed.isEmpty else { return }
                                let newTag = Tag(tag: trimmed)
                                modelContext.insert(newTag)
                                do { try modelContext.save() } catch { print("Failed to save new tag: \(error)") }
                                selectedTag = newTag
                                newTagText = ""
                                isPresentingNewTag = false
                            }
                            .disabled(newTagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            .font(.body)
                            .foregroundColor(
                                newTagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .secondary : .primary
                            )
                        }
                    }
                }
            }
        }
        .onAppear {
            editedLabel = activity.label ?? ""
            editedNotes = activity.notes ?? ""
            selectedTag = activity.tag
        }
        .presentationDetents([.medium, .large])
    }
    
    private func canSave() -> Bool{
        return editedLabel.isEmpty == false || editedNotes.isEmpty == false || selectedTag != activity.tag
    }

    private func saveChanges() {
        activity.label = editedLabel.isEmpty ? nil : editedLabel
        activity.notes = editedNotes.isEmpty ? nil : editedNotes
        activity.tag = selectedTag
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
    let sample = Activity(elapsedSeconds: 3723, label: "Morning Run", notes: "Felt great today", date: Date(), tag: Tag(tag: "Fitness"))
    return LogbookRowView(activity: sample)
        .padding(6)
}

#Preview("Activity Detail Sheet - Editing") {
    let sample = Activity(elapsedSeconds: 5400, label: "Study Session", notes: "Read chapters 3-4", date: Date(), tag: Tag(tag: "Reading"))
    return ActivityDetailSheet(activity: sample)
}

