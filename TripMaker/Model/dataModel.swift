//
//  dataModel.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-17.
//

import Foundation
import SQLite

class DBManager {
    private var db: Connection?

    let routeTable = RouteTable()
    let locationTable = LocationTable()
    let tagTable = TagTable()
    let rewardTable = RewardTable()

    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/db.sqlite3")
            try createTables()
        } catch {
            print("Unable to initialize database: \(error)")
        }
    }

    private func createTables() throws {
        try db?.run(routeTable.table.create(ifNotExists: true) { t in
            t.column(routeTable.routeID, primaryKey: true)
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
    }
    
}

