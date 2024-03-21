//
//  RewardManagement.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-20.
//

import Foundation
import SQLite

extension DBManager {
    
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
        - Description: Fetches a single reward identified by its UUID.
        - Returns: A Reward object if found, otherwise nil.
        */
    func fetchReward(by rewardID: UUID) -> Reward? {
        do {
            let query = rewardTable.table.filter(rewardTable.rewardID == rewardID)
            if let rewardRow = try db?.pluck(query) {
                return Reward(
                    rewardID: rewardRow[rewardTable.rewardID],
                    name: rewardRow[rewardTable.name],
                    picture: rewardRow[rewardTable.picture],
                    isClaimed: rewardRow[rewardTable.isClaimed]
                )
            } else {
                print("No reward found with the given ID.")
                return nil
            }
        } catch {
            print("Database error: \(error)")
            return nil
        }
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
    
    
}
