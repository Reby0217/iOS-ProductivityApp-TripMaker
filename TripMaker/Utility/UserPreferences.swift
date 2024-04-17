//
//  UserPreferences.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-04-16.
//

import Foundation

struct UserPreferences {
    private static let userIDKey = "userIDKey"
    private static var needsRefresh: Bool = true

    static var userID: UUID? {
        get {
            if let idString = UserDefaults.standard.string(forKey: userIDKey), let id = UUID(uuidString: idString) {
                return id
            }
            return nil
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue.uuidString, forKey: userIDKey)
            } else {
                UserDefaults.standard.removeObject(forKey: userIDKey)
            }
        }
    }
    
    static var userProfile: UserProfile? {
        get {
            guard let userID = userID else {
                print("User ID not found.")
                return nil
            }
            
            guard DBManager.shared.isDatabaseReady else {
                print("Database is not ready. Still setting it up...")
                return nil
            }
            
            do {
                return try DBManager.shared.fetchUserProfile(userID: userID)
            } catch {
                print("Error fetching user profile: \(error)")
                return nil
            }
        }
    }
    
    static func invalidateUserProfileCache() {
        needsRefresh = true
        print("User profile cache has been invalidated.")
    }
    
    static var userName: String {
        get {
            userProfile?.username ?? "Snow White"
        }
        set {
            guard let userID = userID else { return }
            do {
                try DBManager.shared.updateUsername(userID: userID, newUsername: newValue)
                // Refreshing userProfile implicitly by accessing it after the update
                let updatedProfile = userProfile //triggers the fetch
                print("Updated profile for: \(String(describing: updatedProfile?.username))")
            } catch {
                print("Error updating username in database: \(error)")
            }
        }
    }
}
