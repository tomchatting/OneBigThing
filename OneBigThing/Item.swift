//
//  Item.swift
//  OneBigThing
//
//  Created by Thomas Chatting on 29/04/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
