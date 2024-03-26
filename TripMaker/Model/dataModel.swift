//
//  dataModel.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-17.
//

import UIKit
import Foundation
import SQLite

class DBManager {
    static let shared = DBManager()
    
    var db: Connection?

    let routeTable = RouteTable()
    let locationTable = LocationTable()
    let tagTable = TagTable()
    let rewardTable = RewardTable()
    let focusSessionTable = FocusSessionTable()
    let locationVisitedTable = LocationVisitedTable()
    let userProfileTable = UserProfileTable()
    let userRouteTable = UserRouteTable()
    let userRewardTable = UserRewardTable()

    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/db.sqlite3")
            try createTables()
            deleteAllData()
            try insertInitialData()
        } catch {
            print("Unable to initialize database: \(error)")
        }
    }

    private func createTables() throws {
        try db?.run(routeTable.table.create(ifNotExists: true) { t in
            t.column(routeTable.name, primaryKey: true)
            t.column(routeTable.mapPicture)
        })

        try db?.run(locationTable.table.create(ifNotExists: true) { t in
            t.column(locationTable.route)
            t.column(locationTable.name, primaryKey: true)
            t.column(locationTable.realPicture)
            t.column(locationTable.description)
            t.column(locationTable.isLocked)
            t.foreignKey(locationTable.route, references: routeTable.table, routeTable.name, delete: .cascade)
        })

        try db?.run(tagTable.table.create(ifNotExists: true) { t in
            t.column(tagTable.location)
            t.column(tagTable.tag, primaryKey: true)
            t.foreignKey(tagTable.location, references: locationTable.table, locationTable.name, delete: .cascade)
        })

        try db?.run(rewardTable.table.create(ifNotExists: true) { t in
            t.column(rewardTable.name, primaryKey: true)
            t.column(rewardTable.picture)
            t.column(rewardTable.isClaimed)
        })
        
        try db?.run(userProfileTable.table.create(ifNotExists: true) { t in
            t.column(userProfileTable.userID, primaryKey: true)
            t.column(userProfileTable.username)
            t.column(userProfileTable.image)
            t.column(userProfileTable.dayTotal)
            t.column(userProfileTable.weekTotal)
            t.column(userProfileTable.monthTotal)
            t.column(userProfileTable.yearTotal)
        })
        
        try db?.run(userRouteTable.table.create(ifNotExists: true) { t in
            t.column(userRouteTable.userID)
            t.column(userRouteTable.route)
            t.unique(userRouteTable.userID, userRouteTable.route)
            
            t.foreignKey(userRouteTable.userID, references: userProfileTable.table, userProfileTable.userID, delete: .cascade)
            t.foreignKey(userRouteTable.route, references: routeTable.table, routeTable.name, delete: .cascade)
        })
        
        try db?.run(userRewardTable.table.create(ifNotExists: true) { t in
            t.column(userRewardTable.userID)
            t.column(userRewardTable.reward)
            t.unique(userRewardTable.userID, userRewardTable.reward)
            
            t.foreignKey(userRewardTable.userID, references: userProfileTable.table, userProfileTable.userID, delete: .cascade)
            t.foreignKey(userRewardTable.reward, references: rewardTable.table, rewardTable.name, delete: .cascade)
        })
        
        try db?.run(focusSessionTable.table.create(ifNotExists: true) { t in
            t.column(focusSessionTable.focusSessionID, primaryKey: true)
            t.column(focusSessionTable.userID)
            t.column(focusSessionTable.startTime)
            t.column(focusSessionTable.endTime)
            t.foreignKey(focusSessionTable.userID, references: userProfileTable.table, userProfileTable.userID, delete: .cascade)
        })
        
        try db?.run(locationVisitedTable.table.create(ifNotExists: true) { t in
            t.column(locationVisitedTable.focusSessionID)
            t.column(locationVisitedTable.location)
            t.unique(locationVisitedTable.focusSessionID, locationVisitedTable.location)
            
            t.foreignKey(locationVisitedTable.focusSessionID, references: focusSessionTable.table, focusSessionTable.focusSessionID, delete: .cascade)
            t.foreignKey(locationVisitedTable.location, references: locationTable.table, locationTable.name, delete: .cascade)
        })
    }
 
    private func insertInitialData() throws {
        guard let map_taiwan = UIImage(named: "taiwan-attractions-map.jpg"),
              let profilePic = UIImage(named: "profilePic.jpg"),
              let rewardImage = UIImage(named: "reward.png") else {
            print("Failed to load initial images.")
            return
        }
        
        let mapPictureString = stringFromImage(map_taiwan)
        let profilePicString = stringFromImage(profilePic)
        let rewardImageString = stringFromImage(rewardImage)
        
        try addRoute(name: "Taiwan", mapPicture: mapPictureString)
        
        let userID = try createUserProfile(username: "Snow White", image: profilePicString)
        
        try addReward(name: "First Reward", picture: rewardImageString)
        
        try claimReward(userID: userID, rewardName: "First Reward")
    }
}

