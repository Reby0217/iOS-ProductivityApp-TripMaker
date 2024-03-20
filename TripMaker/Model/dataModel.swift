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
    
    
    // MARK: Methods for Route
    
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
    - Description: Deletes a route with given UUID from the database.
    - Returns: void
    */
    func deleteRoute(routeID: UUID) throws {
        let route = routeTable.table.filter(routeTable.routeID == routeID)
        try db?.run(route.delete())
    }
    
    
    
    // MARK: Methods for Location
    
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
    - Description: Updates the details of an existing location identified by locationID.
    - Returns: void
    */
    func updateLocation(locationID: UUID, newName: String, newRealPicture: String, newDescription: String, newIsLocked: Bool) throws {
        let locationToUpdate = locationTable.table.filter(locationTable.locationID == locationID)
        try db?.run(locationToUpdate.update(
            locationTable.name <- newName,
            locationTable.realPicture <- newRealPicture,
            locationTable.description <- newDescription,
            locationTable.isLocked <- newIsLocked
        ))
    }
    
    
    /**
    - Description: Removes an existing location from the database.
    - Returns: void
    */
    func deleteLocation(locationID: UUID) throws {
        let locationToDelete = locationTable.table.filter(locationTable.locationID == locationID)
        try db?.run(locationToDelete.delete())
    }
    
    
    /**
    - Description: Fetches all tags associated with a specific location.
    - Returns: An array of strings representing the tags associated with the location. Returns an empty array if no tags are found or in case of an error.
    */
    func fetchTagsForLocation(locationID: UUID) throws -> [String] {
        let tagsQuery = tagTable.table.filter(tagTable.locationID == locationID).select(tagTable.tag)
        let tagsRecords = try db?.prepare(tagsQuery)
        return tagsRecords?.map { $0[tagTable.tag] } ?? []
    }
    
    
    /**
    - Description: Fetches a single location's details by locationID.
    - Returns: A Location object containing the details of the location.
    */
    func fetchLocationDetails(locationID: UUID) throws -> Location {
        let query = locationTable.table.filter(locationTable.locationID == locationID)
        
        guard let location = try db?.pluck(query) else {
            throw NSError(domain: "Location Not Found!", code: 404, userInfo: nil)
        }
        
        let tags = try fetchTagsForLocation(locationID: locationID)

        return Location(
            name: location[locationTable.name],
            locationID: locationID,
            realPicture: location[locationTable.realPicture],
            tagsArray: tags,
            description: location[locationTable.description],
            isLocked: location[locationTable.isLocked]
        )
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
    
    
    
    // MARK: Methods for Reward
    
    /**
    - Description: Adds a new reward to the database with a specified name and picture.
    - Returns: The UUID of the newly created reward.
    */
    func addReward(name: String, picture: String) throws -> UUID {
        let rewardID = UUID()
        let insert = rewardTable.table.insert(
            rewardTable.rewardID <- rewardID,
            rewardTable.name <- name,
            rewardTable.picture <- picture,
            rewardTable.isClaimed <- false
        )
        try db?.run(insert)
        return rewardID
    }
    
    
    /**
    - Description: Retrieves the details of a specific reward by rewardID.
    - Returns: A Reward object containing the details of the reward.
    */
    func fetchRewardDetails(rewardID: UUID) throws -> Reward {
        let query = rewardTable.table.filter(rewardTable.rewardID == rewardID)
        guard let reward = try db?.pluck(query) else {
            throw NSError(domain: "Reward Not Found", code: 404, userInfo: nil)
        }
        return Reward(
            rewardID: rewardID,
            name: reward[rewardTable.name],
            picture: reward[rewardTable.picture],
            isClaimed: reward[rewardTable.isClaimed]
        )
    }
    
    
    /**
    - Description: Updates the information of an existing reward identified by rewardID.
    - Returns: void
    */
    func updateReward(rewardID: UUID, newName: String, newPicture: String) throws {
        let rewardToUpdate = rewardTable.table.filter(rewardTable.rewardID == rewardID)
        try db?.run(rewardToUpdate.update(
            rewardTable.name <- newName,
            rewardTable.picture <- newPicture
        ))
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
    - Description: Fetches all rewards from the database.
    - Returns: An array of Reward objects representing all the rewards.
    */
    func fetchAllRewards() throws -> [Reward] {
        guard let rewards = try db?.prepare(rewardTable.table) else {
            return []
        }
        return rewards.map { reward in
            Reward(
                rewardID: reward[rewardTable.rewardID],
                name: reward[rewardTable.name],
                picture: reward[rewardTable.picture],
                isClaimed: reward[rewardTable.isClaimed]
            )
        }
    }

    
    /**
    - Description: Deletes a reward from the database using rewardID.
    - Returns: void
    */
    func deleteReward(rewardID: UUID) throws {
        let rewardToDelete = rewardTable.table.filter(rewardTable.rewardID == rewardID)
        try db?.run(rewardToDelete.delete())
    }
    
    
    
    // MARK: Methods for FocusSession
    // TODO: NOT Complete!!!
    
    /**
    - Description: Updates the list of locations visited during a focus session identified by sessionID.
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
        - Description: Deletes a focus session for a user with the specified session ID.
        - Returns: void
    */
    func deleteFocusSession(sessionID: UUID) throws {
        let sessionToDelete = focusSessionTable.table.filter(focusSessionTable.focusSessionID == sessionID)
        let delete = sessionToDelete.delete()
        try db?.run(delete)
    }
    
    
    /**
        - Description: Fetches all location IDs visited during a specific focus session with given sessionID.
        - Returns: An array of location IDs visited during the focus session. Returns an empty array if no locations are visited or in case of an error.
    */
    func fetchVisitedLocationsForSession(sessionID: UUID) throws -> [UUID] {
        let locationsQuery = locationVisitedTable.table.filter(locationVisitedTable.focusSessionID == sessionID)
        let visitedLocationsRecords = try db?.prepare(locationsQuery)
        return visitedLocationsRecords?.map { $0[locationVisitedTable.locationID] } ?? []
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
        
        let visitedLocations = try fetchVisitedLocationsForSession(sessionID: sessionID)
        
        return FocusSession(
            ID: sessionID,
            startTime: session[focusSessionTable.startTime],
            endTime: session[focusSessionTable.endTime],
            locationVisited: visitedLocations
        )
    }
    
    
    
    // MARK: Methods for User Profile
    
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
    - Description: Fetches all route IDs associated with a given user with specified userID.
    - Returns: An array of UUIDs representing the route IDs associated with the user. Returns an empty array if no routes are found or in case of an error.
    */
    func fetchRoutesForUser(userID: UUID) throws -> [UUID] {
        let routesQuery = userRouteTable.table.filter(userRouteTable.userID == userID)
        let routesRecords = try db?.prepare(routesQuery)
        return routesRecords?.map { $0[userRouteTable.routeID] } ?? []
    }
    
    
    /**
    - Description: Retrieves all focus session IDs related to a particular user with specified userID.
    - Returns: An array of UUIDs of the focus sessions associated with the user. An empty array is returned if the user has no focus sessions or in case of an error.
    */
    func fetchFocusSessionsForUser(userID: UUID) throws -> [UUID] {
        let focusSessionQuery = focusSessionTable.table.filter(focusSessionTable.userID == userID)
        let focusSessionRecords = try db?.prepare(focusSessionQuery)
        return focusSessionRecords?.map { $0[focusSessionTable.focusSessionID] } ?? []
    }
    
    
    /**
    - Description: Obtains all reward IDs claimed by a user with specified userID.
    - Returns: An array of UUIDs for the rewards claimed by the user. If the user has not claimed any rewards or in case of an error, an empty array is returned.
    */
    func fetchRewardsForUser(userID: UUID) throws -> [UUID] {
        let rewardsQuery = userRewardTable.table.filter(userRewardTable.userID == userID)
        let rewardsRecords = try db?.prepare(rewardsQuery)
        return rewardsRecords?.map { $0[userRewardTable.rewardID] } ?? []
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
        
        let routeArray = try fetchRoutesForUser(userID: userID)
        let focusSessionArray = try fetchFocusSessionsForUser(userID: userID)
        let rewardsArray = try fetchRewardsForUser(userID: userID)
        
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

