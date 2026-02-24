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
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .foregroundStyle(.primary)
                    .font(.headline.bold())
                Text(title)
                    .foregroundStyle(.primary)
                    .font(.footnote)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .frame(minWidth: 100)
            .background(isSelected ? Color(white: 0.92) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 30))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    HStack(spacing: 16) {
        MenuButton(title: "Stopwatch", systemImage: "stopwatch", isSelected: true) {}
        MenuButton(title: "Logbook", systemImage: "list.bullet", isSelected: false) {}
        MenuButton(title: "Activities", systemImage: "person", isSelected: false) {}
    }
    .padding()
}
