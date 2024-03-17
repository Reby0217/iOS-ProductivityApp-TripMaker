//
//  FocusSession.swift
//  TripMaker
//
//  Created by Megan Lin on 3/17/24.
//

import Foundation

struct FocusSession {
    let ID: UUID
    let startTime: Date
    let endTime: Date
    let locationVisited: [UUID]
}
