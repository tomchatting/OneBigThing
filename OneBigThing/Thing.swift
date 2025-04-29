//
//  Thing.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 29/04/2025.
//

import Foundation
import SwiftData

@Model
final class Thing {
    var timestamp: Date
    var details: String
    var done: Bool
    var doneTimestamp: Date?
    
    init(timestamp: Date, details: String) {
        self.timestamp = timestamp
        self.details = details
        self.done = false
        self.doneTimestamp = nil
    }
}
