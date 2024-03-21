//
//  DataStructures.swift
//  TripMaker
//
//  Created by Megan Lin on 3/21/24.
//

import Foundation

struct Route {
    let routeID: UUID
    let name: String
    let locationArray: [UUID]
    let mapPicture: String
}

struct Location {
    let name: String
    let locationID: UUID
    let realPicture: String
    var tagsArray: [String]
    let description: String
    let isLocked: Bool
}

struct Reward {
    let rewardID: UUID
    let name: String
    let picture: String
    let isClaimed: Bool
}

struct FocusSession {
    let ID: UUID
    let startTime: Date
    let endTime: Date
    let locationVisited: [UUID]
}

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
