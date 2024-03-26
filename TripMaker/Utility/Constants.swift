//
//  Constants.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-21.
//

import Foundation
import UIKit

let rewardImage = UIImage(named: "reward.png")!
let rewardImageString = stringFromImage(rewardImage)
let dummyRewards = [
    Reward(name: "First Reward", picture: rewardImageString, isClaimed: true)
]

let dummyUserProfile = UserProfile(
    userID: UUID(),
    username: "Snow White",
    image: "profilePic",
    routeArray: [],
    focusSession: [],
    dayTotal: 5,
    weekTotal: 40,
    monthTotal: 200,
    yearTotal: 3600,
    rewardsArray: dummyRewards.map{ $0.name }
)
