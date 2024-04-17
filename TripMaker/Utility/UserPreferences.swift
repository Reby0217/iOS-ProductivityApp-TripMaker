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
            guard let userID = userID else { return nil }
            do {
//                print("Fetch user profile successfully.")
                return try DBManager.shared.fetchUserProfile(userID: userID)
            } catch {
                print("Error fetching user profile: \(error)")
                return nil
            }
        }
    }
    
    static func invalidateUserProfileCache() {
        needsRefresh = true
        print("User profile cache invalidated.")
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
