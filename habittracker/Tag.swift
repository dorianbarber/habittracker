//
//  Tags.swift
//  habittracker
//
//  Created by Dorian Barber on 1/29/26.
//

import Foundation
import SwiftData

@Model
final class Tag{
    var tag: String
    
    init(tag: String) {
        self.tag = tag
    }
}
