//
//  CircleActionButton.swift
//  habittracker
//
//  Created by Dorian Barber on 1/12/26.
//


import SwiftUI

struct CircleActionButton: View {
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack { Text(title).font(.headline) }
                .frame(width: 100, height: 100)
                .background(Circle().fill(color))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        CircleActionButton(title: "Reset", color: .gray.opacity(0.15)) {}
        CircleActionButton(title: "Start", color: .green.opacity(0.2)) {}
    }
}
