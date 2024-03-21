//
//  Constants.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-21.
//

import Foundation
import UIKit

let dummyUserProfile = UserProfile(
    userID: UUID(),
    username: "Snow White",
    image: "profilePic",
    routeArray: [],
    focusSession: [],
    dayTotal: 0,
    weekTotal: 0,
    monthTotal: 0,
    yearTotal: 0,
    rewardsArray: []
)

let rewardImage = UIImage(named: "reward.png")!
let rewardImageString = stringFromImage(rewardImage)
let dummyRewards = [
    Reward(rewardID: UUID(), name: "FirstReward", picture: rewardImageString, isClaimed: true)
]
