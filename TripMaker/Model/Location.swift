//
//  Location.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-16.
//

import Foundation

struct Location {
    let name: String
    let locationID: UUID
    let realPicture: String
    var tagsArray: [String]
    let description: String
    let isLocked: Bool
}
