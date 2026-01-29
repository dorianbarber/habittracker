//
//  LogbookView.swift
//  habittracker
//
//  Created by Dorian Barber on 1/12/26.
//


import SwiftUI
import SwiftData

struct LogbookView: View {
    @Query(sort: \Activity.date, order: .reverse) private var activities: [Activity]

    var body: some View {
        List(activities) { activity in
            VStack(alignment: .leading, spacing: 4) {
                LogbookRow(activity: activity)
                if let notes = activity.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }.padding(.vertical, 6)
        }
        .listStyle(.plain)
        .padding()
    }

    private func timeString(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
}

#Preview {
    LogbookView()
}
