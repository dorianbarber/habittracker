//
//  MenuButton.swift
//  habittracker
//
//  Created by Dorian Barber on 1/12/26.
//

import SwiftUI
import SwiftData

struct SaveActivityButton: View {
    @Environment(\.modelContext) private var modelContext
    let elapsedSeconds: Int
    var onSaved: (() -> Void)? = nil
    
    var body: some View {
        Button {
            addToLogbook()
            onSaved?()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.primary)
                Text("Add to Logbook")
                    .font(.body.bold())
                    .foregroundStyle(.primary)
            }
            .font(.body.bold())
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color(white: 0.92))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Add elapsed time to logbook")
        .padding(.horizontal, 20)
    }
    
    private func addToLogbook() {
        let activity = Activity(elapsedSeconds: elapsedSeconds)
        modelContext.insert(activity)
    }
}

#Preview {
    VStack(spacing: 16) {
        SaveActivityButton(elapsedSeconds: 123, onSaved: {})
    }
    .padding()
}
