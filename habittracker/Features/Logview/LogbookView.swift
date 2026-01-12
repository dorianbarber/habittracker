//
//  LogbookView.swift
//  habittracker
//
//  Created by Dorian Barber on 1/12/26.
//


import SwiftUI

struct LogbookView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Logbook")
                .font(.title)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LogbookView()
}
