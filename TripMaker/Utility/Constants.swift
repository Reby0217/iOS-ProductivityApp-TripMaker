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

let route_attractions: [String: [CGPoint]] = [
    "Taiwan" :
        [CGPoint(x: 400 - 50,y: 400 - 298),
        CGPoint(x: 400 - 150,y: 400 - 298),
        CGPoint(x: 400 - 278,y: 400 - 238),
        CGPoint(x: 400 - 324,y: 400 - 150),
        CGPoint(x: 400 - 230,y: 400 - 94),
        CGPoint(x: 400 - 212,y: 400 - 200),
        CGPoint(x: 400 - 131,y: 400 - 164),
        CGPoint(x: 400 - 125,y: 400 - 94),
        CGPoint(x: 400 - 125,y: 400 - 30)],
    "Japan" :
        []
]

let route_segments: [String: [Int: [[String: CGPoint]]]] = [
    "Taiwan":
        [0 : [["startPoint": CGPoint(x: 400 - 125,y: 400 - 0), "endPoint": route_attractions["Taiwan"]![8], "controlPoint": route_attractions["Taiwan"]![8]]],
         1 : [["startPoint": route_attractions["Taiwan"]![8], "endPoint": route_attractions["Taiwan"]![7], "controlPoint": route_attractions["Taiwan"]![8]]],
         2 : [["startPoint": route_attractions["Taiwan"]![7], "endPoint": route_attractions["Taiwan"]![4], "controlPoint": route_attractions["Taiwan"]![7]]],
         3 : [["startPoint": route_attractions["Taiwan"]![4], "endPoint": CGPoint(x: 400 - 319, y: 400 - 100), "controlPoint": CGPoint(x: 400 - 318, y: 400 - 90)], ["startPoint": CGPoint(x: 400 - 317, y: 400 - 97), "endPoint": route_attractions["Taiwan"]![3], "controlPoint": CGPoint(x: 400 - 327, y: 400 - 108)]],
         4: [["startPoint": route_attractions["Taiwan"]![3], "endPoint": CGPoint(x: 400 - 316, y: 400 - 235), "controlPoint": CGPoint(x: 400 - 328, y: 400 - 232)],
             ["startPoint": CGPoint(x: 400 - 320, y: 400 - 232), "endPoint": route_attractions["Taiwan"]![2], "controlPoint": CGPoint(x: 400 - 310, y: 400 - 242)]],
         5: [["startPoint": route_attractions["Taiwan"]![2], "endPoint": CGPoint(x: 400 - 210, y: 400 - 238), "controlPoint": route_attractions["Taiwan"]![2]],
             ["startPoint": CGPoint(x: 400 - 212, y: 400 - 233), "endPoint": CGPoint(x: 400 - 200, y: 400 - 296), "controlPoint": CGPoint(x: 400 - 217, y: 400 - 296)],
             ["startPoint": CGPoint(x: 400 - 203, y: 400 - 295), "endPoint": route_attractions["Taiwan"]![1], "controlPoint": CGPoint(x: 400 - 210, y: 400 - 298)]],
         6: [["startPoint": route_attractions["Taiwan"]![1], "endPoint": route_attractions["Taiwan"]![0], "controlPoint": route_attractions["Taiwan"]![0]]],
         7: [["startPoint": route_attractions["Taiwan"]![0], "endPoint": CGPoint(x: 400 - 0,y: 400 - 298), "controlPoint": route_attractions["Taiwan"]![0]]]
        ],
    "Japan" : [0:[]]
]
