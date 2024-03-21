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
            t.column(routeTable.routeID, primaryKey: true)
            t.column(routeTable.name)
            t.column(routeTable.mapPicture)
        })

        try db?.run(locationTable.table.create(ifNotExists: true) { t in
            t.column(locationTable.locationID, primaryKey: true)
            t.column(locationTable.routeID)
            t.column(locationTable.name)
            t.column(locationTable.realPicture)
            t.column(locationTable.description)
            t.column(locationTable.isLocked)
            t.foreignKey(locationTable.routeID, references: routeTable.table, routeTable.routeID, delete: .cascade)
        })

        try db?.run(tagTable.table.create(ifNotExists: true) { t in
            t.column(tagTable.tagID, primaryKey: true)
            t.column(tagTable.locationID)
            t.column(tagTable.tag)
            t.foreignKey(tagTable.locationID, references: locationTable.table, locationTable.locationID, delete: .cascade)
        })

        try db?.run(rewardTable.table.create(ifNotExists: true) { t in
            t.column(rewardTable.rewardID, primaryKey: true)
            t.column(rewardTable.name)
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
            t.column(userRouteTable.routeID)
            t.unique(userRouteTable.userID, userRouteTable.routeID)
            
            t.foreignKey(userRouteTable.userID, references: userProfileTable.table, userProfileTable.userID, delete: .cascade)
            t.foreignKey(userRouteTable.routeID, references: routeTable.table, routeTable.routeID, delete: .cascade)
        })
        
        try db?.run(userRewardTable.table.create(ifNotExists: true) { t in
            t.column(userRewardTable.userID)
            t.column(userRewardTable.rewardID)
            t.unique(userRewardTable.userID, userRewardTable.rewardID)
            
            t.foreignKey(userRewardTable.userID, references: userProfileTable.table, userProfileTable.userID, delete: .cascade)
            t.foreignKey(userRewardTable.rewardID, references: rewardTable.table, rewardTable.rewardID, delete: .cascade)
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
            t.column(locationVisitedTable.locationID)
            t.unique(locationVisitedTable.focusSessionID, locationVisitedTable.locationID)
            
            t.foreignKey(locationVisitedTable.focusSessionID, references: focusSessionTable.table, focusSessionTable.focusSessionID, delete: .cascade)
            t.foreignKey(locationVisitedTable.locationID, references: locationTable.table, locationTable.locationID, delete: .cascade)
        })
    }
 
    private func insertInitialData() throws {
        let map_taiwan = UIImage(named: "taiwan-attractions-map.jpg")
        guard let mapPictureString = map_taiwan.map({ stringFromImage($0) }) else {
            print("Failed to load or convert map image.")
            return
        }
        
        let routeID = try addRoute(name: "Taiwan", mapPicture: mapPictureString)
        print("Route added with ID: \(routeID)")
    }
}

