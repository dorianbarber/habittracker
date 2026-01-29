//
//  LogbookRow.swift
//  habittracker
//
//  Created by Dorian Barber on 1/28/26.
//

import SwiftUI

struct LogbookRow: View {
    let activity: Activity
    
    var body: some View {
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
    }
    
    private func timeString(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hrs, mins, secs)
    }
}

