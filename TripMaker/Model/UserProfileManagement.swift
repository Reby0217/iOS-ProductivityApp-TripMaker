//
//  UserProfileManagement.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-20.
//

import Foundation
import SQLite

extension DBManager {

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
