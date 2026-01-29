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
                Text("Add to Logbook")
                    .fontWeight(.semibold)
            }
            .font(.headline)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.15))
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
