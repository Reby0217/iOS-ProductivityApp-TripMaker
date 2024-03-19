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
    let focusSessionTable = FocusSessionTable()
    let locationVisitedTable = LocationVisitedTable()
    let userProfileTable = UserProfileTable()
    let userRouteTable = UserRouteTable()
    let userRewardTable = UserRewardTable()

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
        
        try db?.run(focusSessionTable.table.create(ifNotExists: true) { t in
            t.column(focusSessionTable.focusSessionID, primaryKey: true)
            t.column(focusSessionTable.startTime)
            t.column(focusSessionTable.endTime)
            t.foreignKey(focusSessionTable.userID, references: userProfileTable.table, userProfileTable.userID, delete: .cascade)
        })
        
        try db?.run(locationVisitedTable.table.create(ifNotExists: true) { t in
            t.foreignKey(locationVisitedTable.focusSessionID, references: focusSessionTable.table, focusSessionTable.focusSessionID, delete: .cascade)
            t.foreignKey(locationVisitedTable.locationID, references: locationTable.table, locationTable.locationID, delete: .cascade)
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
            t.foreignKey(userRouteTable.userID, references: userProfileTable.table, userProfileTable.userID, delete: .cascade)
            t.foreignKey(userRouteTable.routeID, references: routeTable.table, routeTable.routeID, delete: .cascade)
        })
        
        try db?.run(userRewardTable.table.create(ifNotExists: true) { t in
            t.foreignKey(userRewardTable.userID, references: userProfileTable.table, userProfileTable.userID, delete: .cascade)
            t.foreignKey(userRewardTable.rewardID, references: rewardTable.table, rewardTable.rewardID, delete: .cascade)
        })
    }
    
    
    /**
    - Description: Adds a new route to the database with a specified map picture.
    - Returns: The UUID of the newly created route.
    */
    func addRoute(mapPicture: String) throws -> UUID {
        let routeID = UUID()
        let insert = routeTable.table.insert(
            routeTable.routeID <- routeID,
            routeTable.mapPicture <- mapPicture
        )
        try db?.run(insert)
        return routeID
    }
    
    
    /**
    - Description: Adds a new location to an existing route identified by routeID.
    - Returns: A UUID that uniquely identifies the newly added location.
    */
    func addLocationToRoute(routeID: UUID, name: String, realPicture: String, description: String, isLocked: Bool) throws -> UUID {
        let locationID = UUID()
        let insert = locationTable.table.insert(
            locationTable.locationID <- locationID,
            locationTable.routeID <- routeID,
            locationTable.name <- name,
            locationTable.realPicture <- realPicture,
            locationTable.description <- description,
            locationTable.isLocked <- isLocked
        )
        try db?.run(insert)
        return locationID
    }
    
    
    /**
    - Description: Retrieves all locations associated with a given route ID, including their tags.
    - Returns: An array of Location objects, each representing a location on the route with its associated tags.
    */
    func fetchLocationsForRoute(routeID: UUID) throws -> [Location] {
        let query = locationTable.table.join(tagTable.table, on: locationTable.locationID == tagTable.locationID)
                                        .filter(locationTable.routeID == routeID)
                                        .select(locationTable.table[*], tagTable.tag)

        var locations: [UUID: Location] = [:]

        for row in try db!.prepare(query) {
            let locationID = row[locationTable.locationID]
            let tag = row[tagTable.tag]
            
            if var location = locations[locationID] {
                location.tagsArray.append(tag)
                locations[locationID] = location
            } else {
                var location = Location(
                    name: row[locationTable.name],
                    locationID: locationID,
                    realPicture: row[locationTable.realPicture],
                    tagsArray: [tag],
                    description: row[locationTable.description],
                    isLocked: row[locationTable.isLocked]
                )
                locations[locationID] = location
            }
        }
        
        return Array(locations.values)
    }
    
    
    /**
    - Description: Updates the lock status of a specific location identified by locationID.
    - Returns: void
    */
    func updateLocationLockStatus(locationID: UUID, isLocked: Bool) throws {
        let location = locationTable.table.filter(locationTable.locationID == locationID)
        try db?.run(location.update(locationTable.isLocked <- isLocked))
    }
    
    
    /**
    - Description: Adds a new tag to a location. The tag is associated with the location identified by locationID.
    - Returns: void
    */
    func addTagToLocation(locationID: UUID, tag: String) throws {
        let insert = tagTable.table.insert(
            tagTable.tagID <- UUID(),
            tagTable.locationID <- locationID,
            tagTable.tag <- tag
        )
        try db?.run(insert)
    }
    
    
    /**
    - Description: Retrieves the details of a specific route by routeID, including all the location IDs that belong to the route.
    - Returns: A Route object containing the route ID, array of location IDs, and the map picture
    */
    func fetchRouteDetails(routeID: UUID) throws -> Route {
        let query = routeTable.table.filter(routeTable.routeID == routeID)
        guard let routeRecord = try db?.pluck(query) else {
            throw NSError(domain: "Route Not Found!", code: 404, userInfo: nil)
        }
        
        let mapPicture = routeRecord[routeTable.mapPicture]
        let locationsQuery = locationTable.table.filter(locationTable.routeID == routeID)
        let locationRecords = try db?.prepare(locationsQuery)
        let locationIDs = locationRecords?.map { $0[locationTable.locationID] } ?? []
        
        return Route(routeID: routeID, locationArray: locationIDs, mapPicture: mapPicture)
    }
    
    
    /**
    - Description: Allows a user to claim a reward. The reward identified by rewardID is associated with the user identified by userID.
    - Returns: void
    */
    func claimReward(userID: UUID, rewardID: UUID) throws {
        let insert = userRewardTable.table.insert(
            userRewardTable.userID <- userID,
            userRewardTable.rewardID <- rewardID
        )
        try db?.run(insert)
        
        let query = rewardTable.table.filter(rewardTable.rewardID == rewardID)
        let update = query.update(rewardTable.isClaimed <- true)
        try db?.run(update)
    }

    
    /**
    - Description: Updates the list of locations visited during a focus session. The session is identified by sessionID.
    - Returns: void
    */
    func updateVisitedLocations(sessionID: UUID, visitedLocationIDs: [UUID]) throws {
        for locationID in visitedLocationIDs {
            let insert = locationVisitedTable.table.insert(
                locationVisitedTable.focusSessionID <- sessionID,
                locationVisitedTable.locationID <- locationID
            )
            try db?.run(insert)
        }
    }
    

    /**
    - Description: Creates a new focus session for a user with a start time and a duration.
    - Returns: A UUID that uniquely identifies the newly created focus session.
    */
    func createFocusSession(userID: UUID, startTime: Date, duration: TimeInterval) throws -> UUID {
        let sessionID = UUID()
        let insert = focusSessionTable.table.insert(
            focusSessionTable.focusSessionID <- sessionID,
            focusSessionTable.userID <- userID,
            focusSessionTable.startTime <- startTime,
            focusSessionTable.endTime <- startTime.addingTimeInterval(duration)
        )
        try db?.run(insert)
        return sessionID
    }
    
    
    /**
    - Description: Retrieves the details of a focus session, including the start time, end time, and locations visited, identified by sessionID.
    - Returns: A FocusSession object with the details of the focus session.
    */
    func fetchFocusSessionDetails(sessionID: UUID) throws -> FocusSession {
        let query = focusSessionTable.table.filter(focusSessionTable.focusSessionID == sessionID)
        guard let session = try db?.pluck(query) else {
            throw NSError(domain: "Session Not Found!", code: 404, userInfo: nil)
        }
        
        let locationsQuery = locationVisitedTable.table.filter(locationVisitedTable.focusSessionID == sessionID)
        let visitedLocationsRecords = try db?.prepare(locationsQuery)
        let visitedLocations = visitedLocationsRecords?.map { $0[locationVisitedTable.locationID] } ?? []
        
        return FocusSession(
            ID: sessionID,
            startTime: session[focusSessionTable.startTime],
            endTime: session[focusSessionTable.endTime],
            locationVisited: visitedLocations
        )
    }
    
    /**
    - Description: Creates a new user profile with a username and profile image.
    - Returns: A UUID that uniquely identifies the newly created user profile.
    */
    func createUserProfile(username: String, image: String) throws -> UUID {
        let userID = UUID()
        let insert = userProfileTable.table.insert(
            userProfileTable.userID <- userID,
            userProfileTable.username <- username,
            userProfileTable.image <- image,
            userProfileTable.dayTotal <- 0,
            userProfileTable.weekTotal <- 0,
            userProfileTable.monthTotal <- 0,
            userProfileTable.yearTotal <- 0
        )
        try db?.run(insert)
        return userID
    }
    
    
    /**
    - Description: Fetches a user profile, including routes, focus sessions, and rewards associated with the user identified by userID.
    - Returns: A UserProfile object containing the user's profile details and associated data.
    */
    func fetchUserProfile(userID: UUID) throws -> UserProfile {
        let query = userProfileTable.table.filter(userProfileTable.userID == userID)
        guard let user = try db?.pluck(query) else {
            throw NSError(domain: "User Not Found!", code: 404, userInfo: nil)
        }
        
        let routesQuery = userRouteTable.table.filter(userRouteTable.userID == userID)
        let routesRecords = try db?.prepare(routesQuery)
        let routeArray = routesRecords?.map { $0[userRouteTable.routeID] } ?? []

        let focusSessionQuery = focusSessionTable.table.filter(focusSessionTable.userID == userID)
        let focusSessionRecords = try db?.prepare(focusSessionQuery)
        let focusSessionArray = focusSessionRecords?.map { $0[focusSessionTable.focusSessionID] } ?? []
        
        let rewardsQuery = userRewardTable.table.filter(userRewardTable.userID == userID)
        let rewardsRecords = try db?.prepare(rewardsQuery)
        let rewardsArray = rewardsRecords?.map { $0[userRewardTable.rewardID] } ?? []

        return UserProfile(
            userID: userID,
            username: user[userProfileTable.username],
            image: user[userProfileTable.image],
            routeArray: routeArray,
            focusSession: focusSessionArray,
            dayTotal: user[userProfileTable.dayTotal],
            weekTotal: user[userProfileTable.weekTotal],
            monthTotal: user[userProfileTable.monthTotal],
            yearTotal: user[userProfileTable.yearTotal],
            rewardsArray: rewardsArray
        )
    }
    
    
    /**
    - Description: Fetches the user's statistics, including the total focus time over days, weeks, months, and years for the user identified by userID.
    - Returns: A tuple containing the user's focus time statistics.
    */
    func fetchUserStats(userID: UUID) throws -> (dayTotal: Int, weekTotal: Int, monthTotal: Int, yearTotal: Int) {
        let query = userProfileTable.table.filter(userProfileTable.userID == userID)
        guard let user = try db?.pluck(query) else {
            throw NSError(domain: "User Not Found!", code: 404, userInfo: nil)
        }
        return (
            dayTotal: user[userProfileTable.dayTotal],
            weekTotal: user[userProfileTable.weekTotal],
            monthTotal: user[userProfileTable.monthTotal],
            yearTotal: user[userProfileTable.yearTotal]
        )
    }
    
    
    /**
    - Description: Records a user's trip by associating a user with a route.
    - Returns: void
    */
    func recordUserTrip(userID: UUID, routeID: UUID) throws {
        let insert = userRouteTable.table.insert(
            userRouteTable.userID <- userID,
            userRouteTable.routeID <- routeID
        )
        try db?.run(insert)
    }
    
    
    /**
    - Description: Updates a user's statistics with the new focus time. It increments the day, week, month, and year totals of the user identified by userID.
    - Returns: void
    */
    func updateUserStats(userID: UUID, focusTime: TimeInterval) throws {
        let oneDaySeconds: Double = 86400
        let userProfile = userProfileTable.table.filter(userProfileTable.userID == userID)
        try db?.run(userProfile.update(
            userProfileTable.dayTotal += Int(focusTime / oneDaySeconds),
            userProfileTable.weekTotal += Int(focusTime / (oneDaySeconds * 7)),
            userProfileTable.monthTotal += Int(focusTime / (oneDaySeconds * 30)),
            userProfileTable.yearTotal += Int(focusTime / (oneDaySeconds * 365))
        ))
    }


 
}

