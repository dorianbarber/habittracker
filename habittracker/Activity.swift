//
//  Activity.swift
//  habittracker
//
//  Created by Dorian Barber on 1/25/26.
//

import Foundation
import SwiftData

@Model
class Activity {
    var elapsedSeconds: Int
    var label: String?
    var notes: String?
    var date: Date
    var tag: String?

    init(elapsedSeconds: Int, label: String? = nil, notes: String? = nil, date: Date = Date(), tag: String? = nil) {
        self.elapsedSeconds = elapsedSeconds
        self.label = label
        self.notes = notes
        self.date = date
        self.tag = tag
    }
}
