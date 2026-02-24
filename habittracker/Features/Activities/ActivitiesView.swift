//
//  ActivitiesView.swift
//  habittracker
//
//  Created by Dorian Barber on 1/28/26.
//

//
//  LogbookView.swift
//  habittracker
//
//  Created by Dorian Barber on 1/12/26.
//

import SwiftUI
import SwiftData

struct ActivitiesView: View {

    @Query(sort: \Activity.date, order: .reverse) private var activities: [Activity]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(Array(groupedActivities.enumerated()), id: \.offset) { _, group in
                    let tag = group.key
                    let activities = group.value
                    Section {
                    } header: {
                        HStack {
                            Text(tag?.tag ?? "No Tag")
                                .font(.headline)
                            Spacer()
                            Text(hourSummaryString(sumElapsedSeconds(activities)))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.bottom, 2)
                    }
                }
            }
            .padding()
        }
    }
    
    private var groupedActivities: [(key: Tag?, value: [Activity])] {
        let grouped = Dictionary(grouping: activities, by: { $0.tag })
        // Sort by tag name (nil last)
        return grouped.sorted { lhs, rhs in
            switch (lhs.key, rhs.key) {
            case let (l?, r?): return l.tag.localizedCaseInsensitiveCompare(r.tag) == .orderedAscending
            case (_?, nil): return true
            case (nil, _?): return false
            default: return true
            }
        }
    }
    
    private func sumElapsedSeconds(_ activities: [Activity]) -> Int {
        activities.reduce(0) { $0 + $1.elapsedSeconds }
    }
    
    private func hourSummaryString(_ seconds: Int) -> String {
        if seconds < 3600 {
            return "<1 hour"
        } else {
            let hours = seconds / 3600
            return "\(hours) Hour" + (hours > 1 ? "s" : "")
        }
    }
}

#Preview {
    ActivitiesView()
}
