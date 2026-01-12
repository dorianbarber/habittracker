//
//  MenuButton.swift
//  habittracker
//
//  Created by Dorian Barber on 1/12/26.
//


import SwiftUI

struct MenuButton: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                Text(title)
            }
            .font(.headline)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .glassEffect(isSelected ? Glass.regular.tint(Color.green).interactive() : Glass.clear)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    VStack(spacing: 16) {
        MenuButton(title: "Stopwatch", systemImage: "stopwatch", isSelected: true) {}
        MenuButton(title: "Logbook", systemImage: "list.bullet", isSelected: false) {}
    }
    .padding()
}
