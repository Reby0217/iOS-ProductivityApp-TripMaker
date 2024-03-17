//
//  Tables.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-16.
//

import Foundation
import SQLite

struct RouteTable {
    let table = Table("routes")
    let routeID = Expression<UUID>("routeID") // primary key
    let mapPicture = Expression<String>("mapPicture")
}

struct LocationTable {
    let table = Table("locations")
    let locationID = Expression<UUID>("locationID")
    let routeID = Expression<UUID>("routeID") // foreign key
    let name = Expression<String>("name")
    let realPicture = Expression<String>("realPicture")
    let description = Expression<String>("description")
    let isLocked = Expression<Bool>("isLocked")
}

struct TagTable {
    let table = Table("tags")
    let tagID = Expression<UUID>("tagID") // primary key
    let locationID = Expression<UUID>("locationID") // foreign key
    let tag = Expression<String>("tag")
}

struct RewardTable {
    let table = Table("rewards")
    let rewardID = Expression<UUID>("rewardID") // primary key
    let name = Expression<String>("name")
    let picture = Expression<String>("picture")
    let isClaimed = Expression<Bool>("isClaimed")
}
