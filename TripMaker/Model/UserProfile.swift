//
//  UserProfile.swift
//  TripMaker
//
//  Created by Megan Lin on 3/17/24.
//

import Foundation

struct UserProfile {
    let userID: UUID
    let username: String
    let image: String
    let routeArray: [UUID]
    let focusSession: [UUID]
    let dayTotal: Int
    let weekTotal: Int
    let monthTotal: Int
    let yearTotal: Int
    let rewardsArray: [UUID]
}
