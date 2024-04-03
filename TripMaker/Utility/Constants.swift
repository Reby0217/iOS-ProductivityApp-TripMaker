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

/*
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
 */

let route_attractions: [String: [CGPoint]] = [
    "Taiwan" :
        [
            CGPoint(x: 400 - 125,y: 400 - 30),
            CGPoint(x: 400 - 125,y: 400 - 94),
            CGPoint(x: 400 - 230,y: 400 - 94),
            CGPoint(x: 400 - 318,y: 400 - 101),
            CGPoint(x: 400 - 318,y: 400 - 233),
            CGPoint(x: 400 - 212,y: 400 - 238),
            CGPoint(x: 400 - 180,y: 400 - 298),
            CGPoint(x: 400 - 55,y: 400 - 298)
        ],
    "Japan" :
        []
]

let route_segments: [String: [Int: [String: CGPoint]]] = [
    "Taiwan":
        [0 : ["startPoint": CGPoint(x: 400 - 125,y: 400 - 0), "endPoint": route_attractions["Taiwan"]![0], "controlPoint": calculateControlPoint(start: CGPoint(x: 400 - 125,y: 400 - 0), end: route_attractions["Taiwan"]![0], factor: 0)],
         1 : ["startPoint": route_attractions["Taiwan"]![0], "endPoint": route_attractions["Taiwan"]![1], "controlPoint": calculateControlPoint(start: route_attractions["Taiwan"]![0], end: route_attractions["Taiwan"]![1], factor: 0)],
         2 : ["startPoint": route_attractions["Taiwan"]![1], "endPoint": route_attractions["Taiwan"]![2], "controlPoint": calculateControlPoint(start: route_attractions["Taiwan"]![1], end: route_attractions["Taiwan"]![2], factor: 0)],
         3 : ["startPoint": route_attractions["Taiwan"]![2], "endPoint": route_attractions["Taiwan"]![3], "controlPoint": CGPoint(x:400 - 320, y:400 - 89)],
         4 : ["startPoint": route_attractions["Taiwan"]![3], "endPoint": route_attractions["Taiwan"]![4], "controlPoint": CGPoint(x:400 - 328, y:400 - 166)],
         5 : ["startPoint": route_attractions["Taiwan"]![4], "endPoint": route_attractions["Taiwan"]![5], "controlPoint": CGPoint(x:400 - 315, y:400 - 242)],
         6 : ["startPoint": route_attractions["Taiwan"]![5], "endPoint": route_attractions["Taiwan"]![6], "controlPoint": CGPoint(x:400 - 220, y:400 - 306)],
         7 : ["startPoint": route_attractions["Taiwan"]![6], "endPoint": route_attractions["Taiwan"]![7], "controlPoint": calculateControlPoint(start: route_attractions["Taiwan"]![6], end: route_attractions["Taiwan"]![7], factor: 0)],
        ],
    "Japan":
        [0 : ["startPoint": CGPoint(x: 400 - 125,y: 400 - 0), "endPoint": route_attractions["Taiwan"]![0], "controlPoint": calculateControlPoint(start: CGPoint(x: 400 - 125,y: 400 - 0), end: route_attractions["Taiwan"]![0], factor: 0)]
        ]
]
