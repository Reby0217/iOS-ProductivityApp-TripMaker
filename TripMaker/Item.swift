//
//  Item.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-16.
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
