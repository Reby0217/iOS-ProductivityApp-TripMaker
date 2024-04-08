//
//  Constants.swift
//  TripMaker
//
//  Created by Kejia Liu on 2024-03-21.
//

import Foundation
import UIKit

struct Constants {
    static var userID: UUID? = nil
    
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
    
    static let route_attractions: [String: [CGPoint]] = [
        "Taiwan" :
            [
                CGPoint(x: 400 - 125,y: 400 - 30),
                CGPoint(x: 400 - 125,y: 400 - 94),
                CGPoint(x: 400 - 230,y: 400 - 94),
                CGPoint(x: 400 - 318,y: 400 - 101),
                CGPoint(x: 400 - 318,y: 400 - 233),
                CGPoint(x: 400 - 212,y: 400 - 238),
                CGPoint(x: 400 - 180,y: 400 - 298),
                CGPoint(x: 400 - 55,y: 400 - 298)
            ],
        "Canada" :
            [CGPoint(x: 400 - 125,y: 400 - 30)]
    ]

    static let route_segments: [String: [Int: [String: CGPoint]]] = [
        "Taiwan":
            [0 : ["startPoint": CGPoint(x: 400 - 125,y: 400 - 0), "endPoint": route_attractions["Taiwan"]![0], "controlPoint": calculateControlPoint(start: CGPoint(x: 400 - 125,y: 400 - 0), end: route_attractions["Taiwan"]![0], factor: 0)],
             1 : ["startPoint": route_attractions["Taiwan"]![0], "endPoint": route_attractions["Taiwan"]![1], "controlPoint": calculateControlPoint(start: route_attractions["Taiwan"]![0], end: route_attractions["Taiwan"]![1], factor: 0)],
             2 : ["startPoint": route_attractions["Taiwan"]![1], "endPoint": route_attractions["Taiwan"]![2], "controlPoint": calculateControlPoint(start: route_attractions["Taiwan"]![1], end: route_attractions["Taiwan"]![2], factor: 0)],
             3 : ["startPoint": route_attractions["Taiwan"]![2], "endPoint": route_attractions["Taiwan"]![3], "controlPoint": CGPoint(x:400 - 320, y:400 - 89)],
             4 : ["startPoint": route_attractions["Taiwan"]![3], "endPoint": route_attractions["Taiwan"]![4], "controlPoint": CGPoint(x:400 - 328, y:400 - 166)],
             5 : ["startPoint": route_attractions["Taiwan"]![4], "endPoint": route_attractions["Taiwan"]![5], "controlPoint": CGPoint(x:400 - 315, y:400 - 242)],
             6 : ["startPoint": route_attractions["Taiwan"]![5], "endPoint": route_attractions["Taiwan"]![6], "controlPoint": CGPoint(x:400 - 220, y:400 - 306)],
             7 : ["startPoint": route_attractions["Taiwan"]![6], "endPoint": route_attractions["Taiwan"]![7], "controlPoint": calculateControlPoint(start: route_attractions["Taiwan"]![6], end: route_attractions["Taiwan"]![7], factor: 0)],
            ],
        "Canada":
            [0 : ["startPoint": CGPoint(x: 400 - 125,y: 400 - 0), "endPoint": route_attractions["Canada"]![0], "controlPoint": calculateControlPoint(start: CGPoint(x: 400 - 125,y: 400 - 0), end: route_attractions["Canada"]![0], factor: 0)],
             1 : ["startPoint": route_attractions["Taiwan"]![0], "endPoint": route_attractions["Taiwan"]![0], "controlPoint": calculateControlPoint(start: route_attractions["Taiwan"]![0], end: route_attractions["Taiwan"]![0], factor: 0)],
            ]
    ]
    
    static let route_animation: [String: [Int: Bool]] = [
        "Taiwan": [0 : true, 1 : true, 2 : true, 3 : true, 4 : false, 5 : false, 6 : false, 7 : false],
        "Canada": [0 : true, 1 : true]
    ]
    
}

